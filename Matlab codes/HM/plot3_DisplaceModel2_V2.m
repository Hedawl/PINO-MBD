function [hfig,p] = plot3_DisplaceModel2_V2(TPhi,faces,verts,DefScale,isATime,ifColorBar,FigNum)

if nargin < 5
    ifColorBar = false;
    if nargin < 4
        isATime = false;
    end
end
if size(verts,2) == 4
    verts(:,1) = [];
end

%% 
% ������ʾ
hfig = figure(FigNum);
clf
dt = 0.1;
edges = max(verts(:))*5;
% ʹ�õ�patch����
p = patch( 'Faces', faces, 'Vertices', verts );
% axsz = 0.3 ;
set( gca, 'XLim', [min(verts(:,1)) max(verts(:,1))]+[-1 1].*edges, ...
    'YLim', [min(verts(:,2)) max(verts(:,2))]+[-1 1].*edges, ...
    'ZLim', [min(verts(:,3)) max(verts(:,3))]+[-1 1].*edges );
camlookat( p );
alpha( 0.6 );
axis square equal auto off;

% view( 67,-56 )
view( 156,22 )              % �����ӽ�

% Init userdata������Ҫ�õ����ݺͿؼ������������

%% 
if nargout == 0    
end

cameratoolbar('Show') 

data.FaceVertexItem = 1;
data.DefScale = DefScale;
data.dt = dt;
data.pause = false;
data.ModeChanged = false;

set( hfig, 'userdata', data );  % init displayed mode

if ~isATime
    dat = get( hfig, 'userdata' );  % ��ȡ����
    u = TPhi.* ( dat.DefScale * 1 ); % 
    set( p, 'vertices', verts + u ); % �ı�ڵ�����
    dispVector = dat.DefScale * sqrt( TPhi( :, 1 ) .^ 2 + TPhi( :, 2 ) .^ 2 + TPhi( :, 3 ) .^ 2 ); % �������ʸ��
    faceVertexCData = GetVertCData2( dat.FaceVertexItem, dat.DefScale * TPhi, u, dispVector ) ; % ���㵱ǰ��������Ӧ����ɫֵ����������
    set( p, 'FaceVertexCData', faceVertexCData , 'EdgeColor', 'interp' ); % ������ɫ��ʾ
    if ifColorBar
        maxDef = max(u(:));
        maxDef = maxDef / dat.DefScale;
        tickLabel = 0 : maxDef / 10 : maxDef; % ����colorbar�̶Ȳ���ʾ
        colorbar( 'YTickLabel', { num2str( tickLabel( 1 ) ), num2str( tickLabel( 2 ) ), num2str( tickLabel( 3 ) ), ...
            num2str( tickLabel( 4 ) ), num2str( tickLabel( 5 ) ), num2str( tickLabel( 6 ) ), num2str( tickLabel( 7 ) ), ...
            num2str( tickLabel( 8 ) ), num2str( tickLabel( 9 ) ), num2str( tickLabel( 10 ) ), num2str( tickLabel( 11 ) ) } );
    end
%     axis square equal auto off;
    return;
end

% main loop
ii = 0;
count = 0; % MaxCount = 900;
while count < isATime                     % ishandle( p )  % һ����ѭ��
    count = count+1;
    
    dat = get( hfig, 'userdata' );  % ��ȡ����
    ii = mod( ii + dat.dt, 2 * pi );
    
    u = TPhi.* ( dat.DefScale * sin( ii ) ); % ��ģ̬������в�ֵ����ĵ�ǰʱ�̱�����
    set( p, 'vertices', verts + u ); % �ı�ڵ����꣬���Ƕ����ؼ�
    dispVector = dat.DefScale * sqrt( TPhi( :, 1 ) .^ 2 + TPhi( :, 2 ) .^ 2 + TPhi( :, 3 ) .^ 2 ); % �������ʸ��
    faceVertexCData = GetVertCData2( dat.FaceVertexItem, dat.DefScale * TPhi, u, dispVector ) ; % ���㵱ǰ��������Ӧ����ɫֵ����������
    set( p, 'FaceVertexCData', faceVertexCData , 'EdgeColor', 'interp' ); % ������ɫ��ʾ
    if ifColorBar
        maxDef = max(u(:));
        maxDef = maxDef / dat.DefScale;
        tickLabel = 0 : maxDef / 10 : maxDef; % ����colorbar�̶Ȳ���ʾ
        colorbar( 'YTickLabel', { num2str( tickLabel( 1 ) ), num2str( tickLabel( 2 ) ), num2str( tickLabel( 3 ) ), ...
            num2str( tickLabel( 4 ) ), num2str( tickLabel( 5 ) ), num2str( tickLabel( 6 ) ), num2str( tickLabel( 7 ) ), ...
            num2str( tickLabel( 8 ) ), num2str( tickLabel( 9 ) ), num2str( tickLabel( 10 ) ), num2str( tickLabel( 11 ) ) } );
    end
    drawnow
    pause(0.0001);
end % while










