% November, 2016
function material=mfvl_liquid_water1d(material,physical,value,label)
global mfvl_material1d_fluid;
material.label=label;
material.code=mfvl_new_material1d_code;
material.type=mfvl_material1d_fluid;
material.physical=physical;
material.density=1000;%kg/m^3
material.viscosity=0;
material.heat_capacity=0;%kgm^2/K.s^2
material.thermal_conductivity=0.58;%W/m.K
material.value=value;
end
% end of file