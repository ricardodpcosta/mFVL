% October, 2016
% get new code for mfvl_source_term1d
function res=mfvl_new_source_term1d_code()
persistent mfvl_source_term1d_code;
if(isempty(mfvl_source_term1d_code))
    mfvl_source_term1d_code=5001;
end
res=mfvl_source_term1d_code;
mfvl_source_term1d_code=mfvl_source_term1d_code+1;
end
% end of file