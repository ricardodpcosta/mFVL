% October, 2016
% class for mfvl_materials1d
classdef mfvl_material1d < handle
    properties (Access=public)
        label
        code
        type
        physical
        ei
        density
        viscosity
        heat_capacity
        thermal_conductivity
        value
    end
    methods
        % constructor
        function material=mfvl_material1d(type,physical,density,viscosity,heat_capacity,thermal_conductivity,ei,value,label)
            global mfvl_material1d_solid;
            global mfvl_material1d_fluid;
            switch type
                case 'solid'
                    material.type=mfvl_material1d_solid;
                case 'fluid'
                    material.type=mfvl_material1d_fluid;
                otherwise
                    error('mfvl_material1d : Enter a valid type: ''fluid'' or ''solid''.');
            end
            material.label=label;
            material.code=mfvl_new_material1d_code;
            material.physical=physical;
            material.density=density;
            material.viscosity=viscosity;
            material.heat_capacity=heat_capacity;
            material.thermal_conductivity=thermal_conductivity;
            material.ei=ei;
            material.value=value;%function of temperature
        end
        % delete
        function mfvl_delete(this)
            delete(this);
        end
        % clean
        function mfvl_clean(this)
            this.label='';
            this.code=0;
            this.type=0;
            this.physical=0;
            this.ei=0;
            this.density=0;
            this.viscosity=0;
            this.heat_capacity=0;
            this.thermal_conductivity=0;
            this.value=0;
        end
        % copy
        function mfvl_copy(this,that)
            that.label=this.label;
            that.code=this.code;
            that.type=this.type;
            that.physical=this.physical;
            that.ei=this.ei;
            that.density=this.density;
            that.viscosity=this.viscosity;
            that.heat_capacity=this.heat_capacity;
            that.thermal_conductivity=this.thermal_conductivity;
            that.value=this.value;
        end
        % equal
        function res=mfvl_equal(this,that)
            if  (~strcmp(this.label,that.label) || ...
            that.code~=this.code || ...
            that.type~=this.type || ...
            that.physical~=this.physical || ...
            that.ei~=this.ei || ...
            that.density~=this.density || ...
            that.viscosity~=this.viscosity || ...
            that.heat_capacity~=this.heat_capacity || ...
            that.thermal_conductivity~=this.thermal_conductivity ||...
            that.value~=this.value)
                res=false;
            else
                res=true;
            end
        end
        % getters
        function res=get_label(material)
            res=material.label;
        end
        function res=get_code(material)
            res=material.code;
        end
        function res=get_type(material)
            global mfvl_material1d_solid;
            global mfvl_material1d_fluid;
            if material.type==mfvl_material1d_solid
                res='solid';
            end
            if material.type==mfvl_material1d_fluid
                res='fluid';
            end
        end
        function res=get_physical(material)
            res=material.physical;
        end
        function res=get_density(material)
            res=material.density;
        end
        function res=get_viscosity(material)
            res=material.viscosity;
        end
        function res=get_heat_capacity(material)
            res=material.heat_capacity;
        end
        function res=get_thermal_conductivity(material)
            res=material.thermal_conductivity;
        end
        function res=get_ei(material)
            res=material.ei;
        end
        function res=get_value(material)
            res=material.value;
        end
    end
end
% end of file