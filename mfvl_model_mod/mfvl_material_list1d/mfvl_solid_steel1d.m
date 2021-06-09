% November, 2016
function material=mfvl_solid_steel1d(material,physical,value,label)
global mfvl_material1d_solid;
material.label=label;
material.code=mfvl_new_material1d_code;
material.type=mfvl_material1d_solid;
material.physical=physical;
material.density=7800;%kg/m^3
material.viscosity=0;
material.heat_capacity=0;%kgm^2/K.s^2
material.thermal_conductivity=52;%W/m.K
material.value=value;
end
% end of file