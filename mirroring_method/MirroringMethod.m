classdef MirroringMethod < handle
    % Implementation of the mirroring method (method of images) for 2D magnetic problem.
    %
    %    Mirroring method for magnetic field computation of conductors surrounded by magnetic materials.
    %
    %    The following results can be extracted:
    %        - magnetic field (vector or norm)
    %        - inductance matrix
    %        - energy
    %
    %    Different boundary conditions are included:
    %        - conductors in free space (no magnetic boundary)
    %        - conductors surrounded by a single magnetic boundary
    %        - conductors surrounded by two parallel magnetic boundaries
    %        - conductors surrounded by a box of four magnetic boundaries
    %
    %    The following additional features and constraints exist:
    %        - a finite permeability can be considered for the boundary conditions
    %        - the conductors are accepted to be round with an uniform current density
    %        - the radius and the position of the different conductors is arbitrary
    %        - line conductors (without zero radius) are accepted
    %        - no HF effects (skin or proximity) are considered (can be added in post-processing)
    %
    %    The implementation allows the vectorized evaluation of many operating conditions:
    %        - the current is given as a matrix
    %        - the row represents the number of conductors
    %        - the column represents the number of operating conditions
    %
    %    Warning: For 2D problem, the energy is infinite for a single conductor (no return path exists).
    %        - then the definition of the inductance is (intrisically) ill-formulated.
    %        - this problem is (partially) adressed by setting a pole at a fixed distance from the conductor.
    %        - for distances greater than the pole distance, the energy is not anymore considered.
    %        - this mean that the energy is only defined is the sum of the currents is zero.
    %
    %    Warning: The line conductors (zero radius) represent singularities.
    %        - the field goes to infinity close to the conductor.
    %        - the inductance is ill-defined.
    %
    %    Warning: The mirroring method can, in some case, features a high computational cost.
    %        - for some problem, many images can be required.
    %        - if many conductors are simulated, the (non-sparse) matrices are large.
    %
    %    References for the mirroring method:
    %        - Muehlethaler, J. / Modeling and Multi-Objective Optimization of Inductive Power Components / ETHZ / 2012
    %        - Ferreira, J.A. / Electromagnetic Modelling of Power Electronic Converters /Kluwer Academics Publishers / 1989.
    %        - Bossche, A. and Valchev, V. / Inductors and Transformers for Power Electronics / CRC Press / 2005.
    %        - Binns, K.J. and Lawrenson, P. J. / Analysis and Computation of Electric and Magnetic Field Problems / Elsevier/ 1973
    %
    %    (c) 2016-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod
    
    %% properties
    properties (SetAccess = private, GetAccess = private)
        bc % struct: user defined boundary condition
        conductor % struct: user defined conductors
        mirror_conductor_obj % MirrorConductor: manage the mirror placement
        mirror_check_obj % MirrorCheck: check the validity of the provided data
        mirror_physics_obj % MirrorPhysics: compute the magnetic properties
    end
    
    %% init
    methods (Access = public)
        function self = MirroringMethod(bc, conductor)
            % Constructor.
            %
            %    Parameters:
            %        bc (struct): definition of the boundary conditions (type, position, permeability, number of mirror)
            %        conductor (struct): definition of the conductors (position, radius, number)
            
            % set data
            self.bc = bc;
            self.conductor = conductor;
            
            % check the validity of the problem
            self.mirror_check_obj = MirrorCheck(self.bc, self.conductor);
            self.mirror_check_obj.check_data();
            
            % create the mirror
            self.mirror_conductor_obj = MirrorConductor(self.bc, self.conductor);
            
            % create the physics with the conductors and the mirrored conductors
            conductor_mirror = self.mirror_conductor_obj.get_conductor_mirror();
            distance = self.mirror_conductor_obj.get_distance();
            self.mirror_physics_obj = MirrorPhysics(self.conductor, conductor_mirror, distance);
        end
    end
    
    %% public api
    methods (Access = public)
        function bc = get_bc(self)
            % Get the data with the boundary conditions.
            %
            %    Returns:
            %        bc (struct): user defined boundary conditions
            
            bc = self.bc;
        end
        
        function conductor = get_conductor(self)
            % Get the data with the conductors.
            %
            %    Parameters:
            %        conductor (struct): user defined conductors
            
            conductor = self.conductor;
        end
        
        function [H_x, H_y] = get_H_xy_position(self, x, y, I)
            % Get the vector magnetic field at the defined coordinates.
            %
            %    Parameters:
            %        x (vector): vector with the x coordinates
            %        y (vector): vector with the y coordinates
            %        I (matrix): matrix with the current excitation of the conductors
            %
            %    Returns:
            %        H_x (matrix): matrix with the x componenent of the magnetic field
            %        H_y (matrix): matrix with the y componenent of the magnetic field
            
            self.mirror_check_obj.check_x_y(x, y);
            self.mirror_check_obj.check_I(I);
            [H_x, H_y] = self.mirror_physics_obj.get_H_xy(x, y, I);
        end
        
        function H = get_H_norm_position(self, x, y, I)
            % Get the norm of the magnetic field at the defined coordinates.
            %
            %    Parameters:
            %        x (vector): vector with the x coordinates
            %        y (vector): vector with the y coordinates
            %        I (matrix): matrix with the current excitation of the conductors
            %
            %    Returns:
            %        H (matrix): matrix with the norm of the magnetic field
            
            self.mirror_check_obj.check_x_y(x, y);
            self.mirror_check_obj.check_I(I);
            [H_x, H_y] = self.mirror_physics_obj.get_H_xy(x, y, I);
            H = hypot(abs(H_x), abs(H_y));
        end
        
        function [H_x, H_y] = get_H_xy_conductor(self, I)
            % Get the vector magnetic field at the center of the conductors.
            %
            %    Parameters:
            %        I (matrix): matrix with the current excitation of the conductors
            %
            %    Returns:
            %        H_x (matrix): matrix with the x componenent of the magnetic field
            %        H_y (matrix): matrix with the y componenent of the magnetic field
            
            self.mirror_check_obj.check_I(I);
            [H_x, H_y] = self.mirror_physics_obj.get_H_xy(self.conductor.x, self.conductor.y, I);
        end
        
        function H = get_H_norm_conductor(self, I)
            % Get the norm of the magnetic field at the center of the conductors.
            %
            %    Parameters:
            %        I (matrix): matrix with the current excitation of the conductors
            %
            %    Returns:
            %        H (matrix): matrix with the norm of the magnetic field
            
            self.mirror_check_obj.check_I(I);
            [H_x, H_y] = self.mirror_physics_obj.get_H_xy(self.conductor.x, self.conductor.y, I);
            H = hypot(abs(H_x), abs(H_y));
        end
        
        function E = get_E(self, I)
            % Get the energy stored in the system.
            %
            %    Parameters:
            %        I (matrix): matrix with the current excitation of the conductors
            %
            %    Returns:
            %        E (vector): vector with the stored energy
            
            % get the inductance matrix
            self.mirror_check_obj.check_I(I);
            L = self.mirror_physics_obj.get_L();
            
            % compute the energy if the matrix is valid
            if any(isnan(L(:)))
                E = NaN(1, size(I, 2));
            else
                E = (1./2).*diag((I.'*L)*I).';
            end
        end
        
        function L = get_L(self)
            % Get the inductance matrix between the conductors.
            %
            %    Returns:
            %        L (matrix): matrix with the inductances
            
            L = self.mirror_physics_obj.get_L();
        end
    end
end