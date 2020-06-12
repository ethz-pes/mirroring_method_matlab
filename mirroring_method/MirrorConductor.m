classdef MirrorConductor < handle
    % Mirror the conductors with respect to the boundary conditions.
    %
    %    Find the symmetry axis.
    %    Mirror the conductors.
    %    Weight the mirrored conductors.
    %
    %    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

    %% properties
    properties (SetAccess = private, GetAccess = private)
        bc % struct: user defined boundary condition
        conductor % struct: user defined conductors
        distance % struct: distance to the pole and size of the 2d slice
        bc_mirror % struct: mirror axis geometry for the boundary conditions
        conductor_mirror % struct: all the mirrored conductors
    end
    
    %% init
    methods (Access = public)
        function self = MirrorConductor(bc, conductor)
            % Constructor.
            %
            %    Parameters:
            %        bc (struct): definition of the boundary conditions (type, position, permeability, number of mirror)
            %        conductor (struct): definition of the conductors (position, radius, number)
            
            % set data
            self.bc = bc;
            self.conductor = conductor;
            
            % compute the boundary conditions and the mirrored conductors
            self.init_distance();
            self.init_bc_mirror();
            self.init_conductor_mirror();
        end
    end
    
    %% public api
    methods (Access = public)
        function bc_mirror = get_bc_mirror(self)
            % Get the post processed boundary conditions.
            %
            %    Returns:
            %        bc_mirror (struct): struct with the post processed boundary conditions
            
            bc_mirror = self.bc_mirror;
        end
        
        function distance = get_distance(self)
            % Get the struct with the distances required for the computations.
            %
            %    Returns:
            %        distance (struct): struct with the distances required for the computations
            
            distance = self.distance;
        end
        
        function conductor_mirror = get_conductor_mirror(self)
            % Get the mirrored conductors.
            %
            %    Returns:
            %        conductor_mirror (struct): struct with the mirrored conductors
            
            conductor_mirror = self.conductor_mirror;
        end
    end
    
    %% private api
    methods (Access = private)
        function init_distance(self)
            % Create the struct with the distances required for the computations.
            %
            %    The pole distance is required for the inductance computation.
            %    The length of the conductor is used for scaling the inductance.
            
            self.distance.d_pole = self.bc.d_pole;
            self.distance.z_size = self.bc.z_size;
        end
        
        function self = init_bc_mirror(self)
            % Create the post processed boundary conditions.
            %
            %    Contains the axis for the flipping of the mirror.
            %    Contains the size of the domain to be flipped.
            
            self.bc_mirror.d_x = self.bc.x_max-self.bc.x_min;
            self.bc_mirror.x_flip = (self.bc.x_min+self.bc.x_max)./2;
            self.bc_mirror.d_y = self.bc.y_max-self.bc.y_min;
            self.bc_mirror.y_flip = (self.bc.y_min+self.bc.y_max)./2;
        end
        
        function self = init_conductor_mirror(self)
            % Create the mirrored conductors.
            %
            %    Identify the boundary condition type.
            %    Add the required mirror.

            % init the data
            self.conductor_mirror = struct('x', [], 'y', [], 'k', [], 'idx_conductor', [], 'n_conductor', 0);
            
            % create the different images (without including the original conductors)
            switch self.bc.type
                case 'none'
                    % no magnetic boundary: no mirror
                case 'x_min'
                    % single magnetic boundary: single mirror
                    self.add_image(-1, 0);
                case 'x_max'
                    % single magnetic boundary: single mirror
                    self.add_image(+1, 0);
                case 'y_min'
                    % single magnetic boundary: single mirror
                    self.add_image(0, -1);
                case 'y_max'
                    % single magnetic boundary: single mirror
                    self.add_image(0, +1);
                case 'xx'
                    % two magnetic boundaries: mirror in one direction
                    n_idx = -self.bc.n_mirror:+self.bc.n_mirror;
                    for i=n_idx
                        self.add_image(i, 0);
                    end
                case 'yy'
                    % two magnetic boundaries: mirror in one direction
                    n_idx = -self.bc.n_mirror:+self.bc.n_mirror;
                    for i=n_idx
                        self.add_image(0, i);
                    end
                case 'xy'
                    % four magnetic boundaries: mirror in all directions
                    n_idx = -self.bc.n_mirror:+self.bc.n_mirror;
                    for i=n_idx
                        for j=n_idx
                            self.add_image(i, j);
                        end
                    end
                otherwise
                    error('invalid data');
            end
        end
        
        function add_image(self, idx_x, idx_y)
            % Create an image of the original conductor (avoid duplicated image).
            %
            %    The indices represents the shift with respect to the original conductors.
            %    The indices zero/zero represents the original conductors.
            %    The indices zero/zero is ignored to avoid a duplicated image.
            %
            %    Parameters:
            %        idx_x (integer): x index of the image
            %        idx_y (integer): y index of the image
            
            % prevent the creation of an image which is identical to the orignial conductors
            if (idx_x~=0)||(idx_y~=0)
                self.add_image_sub(idx_x, idx_y);
            end
        end
        
        function add_image_sub(self, idx_x, idx_y)
            % Create an image of the original conductor.
            %
            %    Parameters:
            %        idx_x (integer): x index of the image
            %        idx_y (integer): y index of the image
            
            % shift of the image
            d_x_tmp = idx_x.*self.bc_mirror.d_x;
            d_y_tmp = idx_y.*self.bc_mirror.d_y;
            
            % flip along x axis
            if mod(idx_x, 2)==0
                x = d_x_tmp+self.conductor.x;
            else
                x = d_x_tmp+(2.*self.bc_mirror.x_flip-self.conductor.x);
            end
            
            % flip along y axis
            if mod(idx_y, 2)==0
                y = d_y_tmp+self.conductor.y;
            else
                y = d_y_tmp+(2.*self.bc_mirror.y_flip-self.conductor.y);
            end
            
            % weight of the image
            k_idx = max(abs(idx_x), abs(idx_y));
            k = ((self.bc.mu_core-1)./(self.bc.mu_core+1)).^k_idx;
            k = k.*ones(1, self.conductor.n_conductor);
            
            % index of the imaged conductors with respect to the original conductors
            idx_conductor = 1:self.conductor.n_conductor;
            
            % add the image
            self.conductor_mirror.n_conductor = self.conductor_mirror.n_conductor+self.conductor.n_conductor;
            self.conductor_mirror.x = [self.conductor_mirror.x x];
            self.conductor_mirror.y = [self.conductor_mirror.y y];
            self.conductor_mirror.idx_conductor = [self.conductor_mirror.idx_conductor idx_conductor];
            self.conductor_mirror.k = [self.conductor_mirror.k k];
        end
    end
end