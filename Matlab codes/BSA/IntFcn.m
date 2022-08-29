% ���ֲ����ɼ��ٶ���λ�ƣ���ѡʱ����ֺ�Ƶ�����
function [disint, velint] = IntFcn(acc, t, ts, flag)
if flag == 1
    % ʱ�����
    [disint, velint] = IntFcn_Time(t, acc);
    velenergy = sqrt(sum(velint.^2));
    velint = detrend(velint);
    velreenergy = sqrt(sum(velint.^2));
    velint = velint/velreenergy*velenergy;  
    disenergy = sqrt(sum(disint.^2));
    disint = detrend(disint);
    disreenergy = sqrt(sum(disint.^2));
    disint = disint/disreenergy*disenergy; % �˲�����Ϊ���ֲ�ȥ����ʱ��������ʧ

    % ȥ��λ���еĶ�����
    p = polyfit(t, disint, 2);
    disint = disint - polyval(p, t);
else
    % Ƶ�����
    velint =  iomega(acc, ts, 3, 2);
    velint = detrend(velint);
    disint =  iomega(acc, ts, 3, 1);
    % ȥ��λ���еĶ�����
    p = polyfit(t, disint, 2);
    disint = disint - polyval(p, t);
end
end