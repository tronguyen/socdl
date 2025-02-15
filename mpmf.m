function mpmf(params, ispmf)
% set seed number
if nargin < 2
    ispmf = 1;
end
mlib = params.gsl_lib;
%% Train CTR: call ctr with init from 2-dae above
if ispmf==1, % pmf/cf
    if ~params.coldstart
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-pmf/ctr --directory %s --b 1 --user data/%s/ctr-data/sp%d/train-users.dat --item data/%s/ctr-data/sp%d/train-items.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.save,params.data,params.sp,params.data,params.sp,params.maxepoch,params.nF, params.lv,params.lu,...
            params.save,params.ctr_log);
    else
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-pmf/ctr --directory %s --user data/%s/coldstart/ctr-data/%s/train-users.dat --item data/%s/coldstart/ctr-data/%s/train-items.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.save,params.data,params.coldid,params.data,params.coldid,params.maxepoch,params.nF, params.lv,params.lu,...
            params.save,params.ctr_log);
    end
elseif ispmf == 2 % ctr-chongwang
    if ~params.coldstart
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-bcdl/ctr --theta_opt --mult data/%s/ctr-data/mult.dat --theta_init %s/final-theta.dat --beta_init %s/final-beta.dat --directory %s --user data/%s/ctr-data/train-users.dat --item data/%s/ctr-data/train-items.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.data,params.save,params.save,...
            params.save,params.data,params.data,params.maxepoch,params.nF, params.lv,params.lu,...
            params.save,params.ctr_log);
    else
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-bcdl/ctr --theta_opt --mult data/%s/ctr-data/mult.dat --theta_init %s/final-theta.dat --beta_init %s/final-beta.dat --directory %s --user data/%s/coldstart/ctr-data/%s/train-users.dat --item data/%s/coldstart/ctr-data/%s/train-items.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.data,params.save,params.save,...
            params.save,params.data,params.coldid,params.data,params.coldid,params.maxepoch,params.nF, params.lv,params.lu,...
            params.save,params.ctr_log);
    end
elseif ispmf == 3 % ctr-smf code
    if ~params.coldstart
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-ctrsmf/ctr --theta_opt --mult data/%s/ctr-data/mult.dat --theta_init %s/final-theta.dat --beta_init %s/final-beta.dat --directory %s --user data/%s/ctr-data/train-users.dat --item data/%s/ctr-data/train-items.dat --net data/%s/ctr-data/net-users.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --lambda_q %f --lambda_s %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.data,params.save,params.save,...
            params.save,params.data,params.data,params.data,...
            params.maxepoch,params.nF, params.lv,params.lu,params.lq,params.ls,...
            params.save,params.ctr_log);
    else
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-ctrsmf/ctr --theta_opt --mult data/%s/ctr-data/mult.dat --theta_init %s/final-theta.dat --beta_init %s/final-beta.dat --directory %s --user data/%s/coldstart/ctr-data/%s/train-users.dat --item data/%s/coldstart/ctr-data/%s/train-items.dat --net data/%s/ctr-data/net-users.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --lambda_q %f --lambda_s %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,params.data,params.save,params.save,...
            params.save,params.data,params.coldid,params.data,params.coldid,params.data,...
            params.maxepoch,params.nF, params.lv,params.lu,params.lq,params.ls,...
            params.save,params.ctr_log);  

    end
elseif ispmf == 4 % SoRec code
    if ~params.coldstart
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-sorec/ctr --b 1 --directory %s --user data/%s/ctr-data/sp%d/train-users.dat --item data/%s/ctr-data/sp%d/train-items.dat --net data/%s/ctr-data/net-users.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --lambda_q %f --lambda_s %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,...
            params.save,params.data,params.sp,params.data,params.sp,params.data,...
            params.maxepoch,params.nF, params.lv,params.lu,params.lq,params.ls,...
            params.save,params.ctr_log);
    else
        ctrcmd = sprintf('export LD_LIBRARY_PATH=%s && ctr-part-sorec/ctr --directory %s --user data/%s/coldstart/ctr-data/%s/train-users.dat --item data/%s/coldstart/ctr-data/%s/train-items.dat --net data/%s/ctr-data/net-users.dat --max_iter %d --num_factors %d --lambda_v %f --lambda_u %f --lambda_q %f --lambda_s %f --save_lag 100 --random_seed 123 >> %s/%s', ...
            mlib,...
            params.save,params.data,params.coldid,params.data,params.coldid,params.data,...
            params.maxepoch,params.nF, params.lv,params.lu,params.lq,params.ls,...
            params.save,params.ctr_log);  

    end
end
fprintf(2,'%s\n', ctrcmd);
system(ctrcmd);
params.endproc = 1;
end

