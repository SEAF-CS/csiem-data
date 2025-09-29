clear; close all;

data=load('W:\csiem\csiem-marvl\data\cockburn_oxy.mat');

%%

sites=fieldnames(data.cockburn);

for ss=1:length(sites)
    sitenmae=sites{ss};

    TF=contains(sitenmae,'WC_');

    if sum(TF)>=1
        csiem.(sitenmae)=data.cockburn.(sitenmae);
        
        vars=fieldnames(csiem.(sitenmae));
        for v=1:length(vars)
           csiem.(sitenmae).(vars{v}).Deployment='Fixed';

        end
    end


end

save('csiem_WC_public.mat','csiem','-mat','-v7.3');