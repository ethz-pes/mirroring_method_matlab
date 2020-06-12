classdef MirrorCheck < handle
    % Check the validity of a 2D mirroring problem.
    %
    %    Check if the conductors are correctly located.
    %    Check if the field is evaluated inside the domain.
    %    Check the length of different vectors.
    %
    %    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod
    
    %% properties
    properties (SetAccess = private, GetAccess = private)
        bc % struct: user defined boundary condition
        conductor % struct: user defined conductors
    end
    
    %% init
    methods (Access = public)
        function self = MirrorCheck(bc, conductor)
            % Constructor.
            %
            %    Parameters:
            %        bc (struct): definition of the boundary conditions (type, position, permeability, number of mirror)
            %        conductor (struct): definition of the conductors (position, radius, number)
            
            % set data
            self.bc = bc;
            self.conductor = conductor;
        end
    end
    
    %% public api
    methods (Access = public)
        function check_x_y(self, x, y)
            % Check if the given coordinates are inside the domain.
            %
            %    Parameters:
            %        x (vector): vector with the x coordinates
            %        y (vector): vector with the y coordinates
            
            validateattributes(x, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(y, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
            assert(length(x)==length(y), 'invalid data');
            self.check_in_bc_sub(x, y, 0);
        end
        
        function check_I(self, I)
            % Check if the length of the current matrix is correct.
            %
            %    Parameters:
            %        I (matrix): matrix with the current excitation of the conductors
            
            validateattributes(I, {'double'},{'2d', 'nonempty', 'nonnan','finite'});
            assert(size(I, 1)==self.conductor.n_conductor, 'invalid data');
        end
        
        function check_data(self)
            % Check the validity of the data provided by the user.
            %
            %    Check the data types.
            %    Check boundary conditions.
            %    Check conductors (overlap, inside the boundaries, etc.).
            
            % check conductor
            validateattributes(self.conductor.x, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.conductor.x, {'double'},{'row', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.conductor.d_c, {'double'},{'row', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.conductor.n_conductor, {'double'},{'scalar', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            assert(length(self.conductor.x)==self.conductor.n_conductor, 'invalid data');
            assert(length(self.conductor.y)==self.conductor.n_conductor, 'invalid data');
            assert(length(self.conductor.d_c)==self.conductor.n_conductor, 'invalid data');
            
            % check bc
            valid_type = {'none', 'x_min', 'x_max', 'y_min', 'y_max' , 'xx', 'yy', 'xy'};
            assert(any(strcmp(self.bc.type, valid_type)), 'invalid data');
            validateattributes(self.bc.z_size, {'double'},{'scalar', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.d_pole, {'double'},{'scalar', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.x_min, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.x_max, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.y_min, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.y_max, {'double'},{'scalar', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.n_mirror, {'double'},{'scalar', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            validateattributes(self.bc.mu_core, {'double'},{'scalar', 'nonnegative', 'nonempty', 'nonnan', 'real','finite'});
            
            % check if the conductor are located inside the domain
            self.check_in_bc_sub(self.conductor.x, self.conductor.y, self.conductor.d_c./2);
                        
            % check if no overlap exists between the conductors
            self.check_overlap_sub(self.conductor.x, self.conductor.y, self.conductor.d_c./2);
        end
    end
    
    %% private api
    methods (Access = private)
        function check_overlap_sub(self, x, y, r)
            % Check if the given coordinates do not overlap (within a cylinder radius).
            %
            %    Parameters:
            %        x (vector): vector with the x coordinates
            %        y (vector): vector with the y coordinates
            %        r (vector): radius around the coordinates
            
            % off-diagonal indices
            idx_off = logical(eye(length(r), length(r))==0);
            
            % compute the distances between the conductors
            [x_c_mat_1,x_c_mat_2] = ndgrid(x, x);
            [y_c_mat_1,y_c_mat_2] = ndgrid(y, y);
            d_conductor_square = (x_c_mat_1-x_c_mat_2).^2+(y_c_mat_1-y_c_mat_2).^2;

            % compute the required distances between the conductors
            [r_mat_1,r_mat_2] = ndgrid(r, r);
            d_min_square = (r_mat_1+r_mat_2).^2;
            
            % check that no duplicated conductors exists
            assert(all(all(d_conductor_square(idx_off)>0)), 'invalid data');
            
            % check if no overlap exists between the conductors
            assert(all(all(d_conductor_square(idx_off)>d_min_square(idx_off))), 'invalid data');
        end

        function check_in_bc_sub(self, x, y, r)
            % Check if the given coordinates are inside the domain (within a cylinder radius).
            %
            %    Parameters:
            %        x (vector): vector with the x coordinates
            %        y (vector): vector with the y coordinates
            %        r (vector): radius around the coordinates
            
            assert(all((x-r)>=self.bc.x_min), 'invalid data')
            assert(all((x+r)<=self.bc.x_max), 'invalid data')
            assert(all((y-r)>=self.bc.y_min), 'invalid data')
            assert(all((y+r)<=self.bc.y_max), 'invalid data')
        end
    end
end