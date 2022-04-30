function out=GetAdhesionEnergyDiff(cells, sigma, rnd_x, rnd_y, c, nb_c)

global J_DD J_LL J_DL J_DM J_LM;

e_adhesion = 0; new_e_adhesion = 0;

local_mat=sigma(rnd_y-1:rnd_y+1,rnd_x-1:rnd_x+1);
local_mat=reshape(local_mat,numel(local_mat),1);
local_mat(5)=[];

before_mat=local_mat(local_mat~=c);

if c>0 && cells.type(c)==2 % when the dark cell is chosen as a source cell
    e_adhesion = e_adhesion + J_DD*sum(cells.type(before_mat(before_mat>0))==2); %#ok<*FNDSB>
    e_adhesion = e_adhesion + J_DL*sum(cells.type(before_mat(before_mat>0))==1);
    e_adhesion = e_adhesion + J_DM*sum(before_mat==0);
elseif c>0 && cells.type(c)==1 % when the light cell is chosen as a source cell
    e_adhesion = e_adhesion + J_LL*sum(cells.type(before_mat(before_mat>0))==1);
    e_adhesion = e_adhesion + J_DL*sum(cells.type(before_mat(before_mat>0))==2);
    e_adhesion = e_adhesion + J_LM*sum(before_mat==0);
elseif c==0 % when the medium is chosen as a source cell
    e_adhesion = e_adhesion + J_DM*sum(cells.type(before_mat(before_mat>0))==2);
    e_adhesion = e_adhesion + J_LM*sum(cells.type(before_mat(before_mat>0))==1);
end

after_mat=local_mat(local_mat~=nb_c);

if nb_c>0 && cells.type(nb_c)==2 % when the dark cell is chosen as a target cell
    new_e_adhesion = new_e_adhesion + J_DD*sum(cells.type(after_mat(after_mat>0))==2);
    new_e_adhesion = new_e_adhesion + J_DL*sum(cells.type(after_mat(after_mat>0))==1);
    new_e_adhesion = new_e_adhesion + J_DM*sum(after_mat==0);
elseif nb_c>0 && cells.type(nb_c)==1 % when the light cell is chosen as a target cell
    new_e_adhesion = new_e_adhesion + J_LL*sum(cells.type(after_mat(after_mat>0))==1);
    new_e_adhesion = new_e_adhesion + J_DL*sum(cells.type(after_mat(after_mat>0))==2);
    new_e_adhesion = new_e_adhesion + J_LM*sum(after_mat==0);
elseif nb_c==0 % when the medium is chosen as a target cell
    new_e_adhesion = new_e_adhesion + J_DM*sum(cells.type(after_mat(after_mat>0))==2);
    new_e_adhesion = new_e_adhesion + J_LM*sum(cells.type(after_mat(after_mat>0))==1);
end

out = new_e_adhesion - e_adhesion;

end