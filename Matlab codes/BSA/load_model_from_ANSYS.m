
function [Nodes, Solids] = load_model_from_ANSYS(file_name)
%% 

% file_name = 'D:\ANSYS\���ɽ\file2.cdb';  
% [Nodes, Solids] = load_model_from_ANSYS(file_name);
% Nodes ------ 1-4�У��ڵ��ţ�xyz����

%% ��ȡ����Ԫ�ļ��ι�ϵ

fname = file_name;                        % ENGINEERINGCALCULATION.cdb
NBLOCK_str = 'NBLOCK,%d,SOLID,%d,%d';     % ANSYS��NBLOCK���ĸ�ʽ      �ֱ�Ϊ�ֶ���6����������ڵ�����д��Ľڵ���
EBLOCK_str = 'EBLOCK,%d,SOLID,%d,%d';     % ������
solid_str = get_str_format(19);           % format--��ʽ   Ϊʲô��19��'%d'

% Geo = importdata(fname);
fid = fopen(fname,'r');             % ���ļ� filename �Ա��Զ����ƶ�ȡ��ʽ���з��ʣ������ص��ڻ���� 3 �������ļ���ʶ���� ��� fopen �޷����ļ����� fileID Ϊ -1��

tline = fgetl(fid);                 % �� fid ���ݸ� fgetl �����Դ��ļ���ȡһ�С�����ɾ�����з���
while ischar(tline)          % ȷ�������Ƿ�Ϊ�ַ�����,�ǣ������߼�ֵ1
    if strcmp(tline(1:min([length(tline), 6])),'NBLOCK')   % �ڵ����ݿ��  �ֶ�����6  tf = strcmp(s1,s2) �Ƚ� s1 �� s2�����������ͬ���򷵻� 1 (true)
        sizeNodes = sscanf(tline, NBLOCK_str); % ���'NBLOCK,%d,SOLID,%d,%d'�ֱ�Ϊ�ֶ���6����������ڵ�����д��Ľڵ���
        num = sizeNodes(2);                    % ��������ڵ���
        Nodes = zeros(num,sizeNodes(1));
        tline = fgetl(fid); %#ok<NASGU>  % ��Ծһ��
        tline = fgetl(fid);
        for itr = 1:num
            vec = textscan(tline,'%f');   % ���ı��ļ����ַ�����ȡ��ʽ������ ��cdb�ļ��е�����
            Nodes(itr,1:length(vec{1})) = vec{1};
            tline = fgetl(fid);
        end
        Nodes(:,[2 3]) = [];     % cdb�е�2-3������Ϊ0   ԭ����4-6��Ϊ�ڵ���ά����
        
    elseif strcmp(tline(1:min([length(tline), 6])),'EBLOCK')
        sizeNodes = sscanf(tline, EBLOCK_str);
        num = sizeNodes(2);                   % ��������Ԫ��
        Solids = zeros(num,19)*NaN;
        tline = fgetl(fid); %#ok<NASGU>  % ��Ծһ��
        tline = fgetl(fid);
        for itr = 1:num
            vec = sscanf(tline,solid_str);
            Solids(itr,1:length(vec)) = vec;
            tline = fgetl(fid);
        end
        break;
    else
        tline = fgetl(fid);
    end
end
fclose(fid);                    % �ر��ļ�

% Solid(:,1) = [];

% Solid(isnan(sum(Solid,2)),:) = [];
AAA=1;

%% 
function format_str = get_str_format(n)      % n = 19
format_str = '';
for itr = 1:n
    format_str = [format_str '%d ']; %#ok<AGROW>
end










