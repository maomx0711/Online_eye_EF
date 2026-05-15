%% INITIALIZING EYELINk
ID='huanghuiyingqq';
% define name of EL file
if IsOctave
    edfFile = 'DEMO';
else
    edfFile = 'eye';  %name
end
useOfEyelink = 1;
gray = 0.5;
HideCursor
Experimenter='1';
dummymode=0;
screenNumber=max(Screen('Screens'));
[widthPx, heightPx]=WindowSize(screenNumber);
window=Screen('OpenWindow', screenNumber);
% initializations
el=EyelinkInitDefaults(window);

el.backgroundcolour = [gray gray gray];
el.msgfontcolour  = 255;
el.imgtitlecolour = 255;
el.targetbeep = 0;
el.calibrationtargetcolour =  255;
el.calibrationtargetsize= 1;
el.calibrationtargetwidth=0.5;
EyelinkUpdateDefaults(el);

%connection with eyetracker, opening file

if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    cleanup(useOfEyelink, edfFile);
    return;
end
i = Eyelink('Openfile', edfFile);
if i~=0
    fprintf('Cannot create EDF file ''%s'' ', edfFile);
    cleanup(useOfEyelink, edfFile);
    return;
end
if Eyelink('IsConnected')~=1 && ~dummymode
    cleanup(useOfEyelink, edfFile);
    return;
end;

%configure eye tracker
Eyelink('command', 'add_file_preamble_text ''Recorded by %s''', Experimenter);
% This command is crucial to map the gaze positions from the tracker to
% screen pixel positions to determine fixation
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, widthPx-1, heightPx-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, widthPx-1, heightPx-1);
Eyelink('command', 'calibration_type = HV5 '); %Eyelink('command', 'calibration_type = HV9');
Eyelink('command', 'generate_default_targets = YES');
% set parser (conservative saccade thresholds)
Eyelink('command', 'saccade_velocity_threshold = 35');
Eyelink('command', 'saccade_acceleration_threshold = 9500');
% set EDF file contents
% retrieve tracker version and tracker software version
[v,vs] = Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );
vsn = regexp(vs,'\d','match');
if v ==3 && str2double(vsn{1}) == 4 % if EL 1000 and tracker version 4.xx
    % remote mode possible add HTARGET ( head target)
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET');
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT,HTARGET');
else
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
    % set link data (used for gaze cursor)
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
end
% calibration/drift correction target
Eyelink('command', 'button_function 5 "accept_target_fixation"');

%enter Eyetracker camera setup mode, calibration and validation
EyelinkDoTrackerSetup(el);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Center Flanker stimuli %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runNum=3;
lum2=85;
LUMINANCE=127;
Orientation1=90;
Orientation2=-Orientation1;
bar_lum=1;
size=60;
rest=45;
awa=1;
TrialNum=120;
NO_TARGET_LOCATION=-1;
result=zeros(8,TrialNum);
Screen('Preference', 'SkipSyncTests', 1);
leftKey=KbName('n');% left
rightKey=KbName('m');% right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get screen
Screens=Screen('Screens');
ScreenNumber=max(Screens);
HideCursor
% open a black screen
Black=BlackIndex(ScreenNumber);
white=WhiteIndex(ScreenNumber);
Black=(Black+white)/2;
[w,wRect]=Screen('OpenWindow',ScreenNumber,Black);
FixationRect=CenterRect([0,0,8,8],[0,0,1280,1024]);

EscapeKey = KbName('q');
TriggerKey = KbName('s');
Text='Waiting for the trigger to start...';
%%% Main EXP
%%%%%%%%%%%fix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ground
gr_x=1000;
gr_y=1000;
%%%%%%%%%%%%%
ground=uint8(ones(gr_x,gr_y,3))*LUMINANCE;
ground(gr_x/2:gr_x/2+2,(gr_y/2-9):(gr_y/2+11),:)=192;
ground((gr_x/2-9):(gr_x/2+11),gr_y/2:gr_y/2+2,:)=192;
att=Screen('MakeTexture',w,ground);

%% arrow picture
width = size;
height = size;
arrow_ground=cell(1,2);
arrow_ground{1,1} = uint8(ones(height, width,3)*LUMINANCE);
arrow_ground{1,2} = uint8(ones(height, width,3)*LUMINANCE);
triangle_side = size;
triangle_side2=size-10;
triangle_side3=size-12;
Orientation1=90;
Orientation2=-90;
triangle_height = sqrt(triangle_side^2 - (triangle_side/2)^2);
triangle_height2 = sqrt(triangle_side2^2 - (triangle_side2/2)^2);
triangle_height3 = sqrt(triangle_side3^2 - (triangle_side3/2)^2);
top_vertex = [width/2, height/2 - triangle_height/2];
left_vertex = [width/2 - triangle_side/2, height/2 + triangle_height/2];
right_vertex = [width/2 + triangle_side/2, height/2 + triangle_height/2];
top_vertex2 = [width/2, height/2 + triangle_height/2 - triangle_height2];
left_vertex2 = [width/2 - triangle_side2/2, height/2 + triangle_height/2];
right_vertex2 = [width/2 + triangle_side2/2, height/2 + triangle_height/2];
top_vertex3 = [width/2, height/2 + triangle_height/2 - triangle_height3];
left_vertex3 = [width/2 - triangle_side3/2, height/2 + triangle_height/2];
right_vertex3 = [width/2 + triangle_side3/2, height/2 + triangle_height/2];
for i=1:2
if i==1
        arrow_lum=lum2;
          
for x = 1:width
    for y = 1:height
        if inpolygon(x, y, [top_vertex(1), left_vertex(1), right_vertex(1)], [top_vertex(2), left_vertex(2), right_vertex(2)])
            arrow_ground{i}(y, x,:) = arrow_lum;
            if inpolygon(x, y, [top_vertex2(1), left_vertex2(1), right_vertex2(1)], [top_vertex2(2), left_vertex2(2), right_vertex2(2)])
            arrow_ground{i}(y, x,:) = LUMINANCE;
            end
        end
    end
end
elseif i==2
        arrow_lum=bar_lum;
   
for x = 1:width
    for y = 1:height
        if inpolygon(x, y, [top_vertex(1), left_vertex(1), right_vertex(1)], [top_vertex(2), left_vertex(2), right_vertex(2)])
            arrow_ground{i}(y, x,:) = arrow_lum;
            if inpolygon(x, y, [top_vertex3(1), left_vertex3(1), right_vertex3(1)], [top_vertex3(2), left_vertex3(2), right_vertex3(2)])
            arrow_ground{i}(y, x,:) = LUMINANCE;
            end
        end
    end
end
 end
end
arrow_L=imrotate(arrow_ground{1},Orientation1,'bicubic','crop');
arrow_R=imrotate(arrow_ground{1},Orientation2,'bicubic','crop');
Cue_arrow_L=imrotate(arrow_ground{2},Orientation1,'bicubic','crop');
Cue_arrow_R=imrotate(arrow_ground{2},Orientation2,'bicubic','crop');

%% arrow ground location
n=9;
distance=size+10;
wid=width/2;
heig=height/2;
for m=1:n
    if m<=5
        o_x(m)=gr_x/2-size/2;
        o_y(m)=gr_y/2-(wid)+distance*(m-1);
    elseif m>5
        o_x(m)=gr_x/2-size/2;
        o_y(m)=gr_y/2-(wid)-distance*(m-5);
    end
end
%% make cue
Cue_ground=uint8(ones(gr_x,gr_y,3)*LUMINANCE);
for m=1:n
    if m<=5
        line_x(m)=gr_x/2;
        line_y(m)=gr_y/2-(wid)+distance*(m-1);
    elseif m>5
        line_x(m)=gr_x/2;
        line_y(m)=gr_y/2-(wid)-distance*(m-5);
    end
    Cue_ground((line_x(m)):(line_x(m)+2),(line_y(m)):(line_y(m)+width),:)=255;
end
Cue_arrow=Screen('MakeTexture',w,Cue_ground);

%% Conground
ground=uint8(ones(gr_x,gr_y,3))*LUMINANCE;
C_arrow_ground{1}=ground;
C_arrow_ground{2}=ground;
for ori=1:2
    if ori==1
       arrow_pic=arrow_R;
    else
       arrow_pic=arrow_L;
    end
    for m=1:9
       for i=1:width
           for j=1:height  
            C_arrow_ground{ori}(o_x(m)+i,o_y(m)+j,:)=arrow_pic(i,j,:);
           end
       end
    end
end
%% Incongrount
ground=uint8(ones(gr_x,gr_y,3))*LUMINANCE;
IC_arrow_ground{1}=ground;
IC_arrow_ground{2}=ground;
for ori=1:2
    if ori==1
       arrow_pic=arrow_R;
     for m=1:9
        if m==1
            arrow_pic=arrow_R;
        else
            arrow_pic=arrow_L;
        end
          for i=1:width
           for j=1:height          
        IC_arrow_ground{ori}(o_x(m)+i,o_y(m)+j,:)=arrow_pic(i,j,:);    
           end
          end
      end
    elseif ori==2
       arrow_pic=arrow_L;
     for m=1:9
        if m==1
            arrow_pic=arrow_L;
        else
            arrow_pic=arrow_R;
        end
         for i=1:width
           for j=1:height  
        IC_arrow_ground{ori}(o_x(m)+i,o_y(m)+j,:)=arrow_pic(i,j,:);
           end
         end
      end
      
    end
 end

%% set location
lo1=ones(1,2*TrialNum/15)*1;
lo2=ones(1,TrialNum/15)*2;
lo3=ones(1,TrialNum/15)*3;
lo4=ones(1,TrialNum/15)*4;
lo5=ones(1,TrialNum/15)*5;
lo6=ones(1,TrialNum/15)*6;
lo7=ones(1,TrialNum/15)*7;
lo8=ones(1,TrialNum/15)*8;
lo9=ones(1,TrialNum/15)*9;
lo=[lo1 lo2 lo3 lo4 lo5 lo6 lo7 lo8 lo9 ];

trialTypeOrder=zeros(1,TrialNum);
tar_type=randperm(TrialNum);
target=cell(1,TrialNum);
r=size/2;
for t=1:TrialNum
    Cground=ground;
    type=rem(tar_type(t),4)+1;
    trialTypeOrder(t)=type;
    result(1,t)=tar_type(t);
    if tar_type(t)<=(2*TrialNum)/3
        loc=lo(tar_type(t));

if type==1
Tar_picture=Cue_arrow_R;
Dis_picture=Cue_arrow_R;
Cground=C_arrow_ground{1};
   if loc==1;
       draw_pic=Tar_picture;
   else
       draw_pic=Dis_picture;
   end 
elseif type==2
Tar_picture=Cue_arrow_R;
Dis_picture=Cue_arrow_L;
Cground=IC_arrow_ground{1};
   if loc==1;
       draw_pic=Tar_picture;
   else
       draw_pic=Dis_picture;
   end 
elseif type==3
Tar_picture=Cue_arrow_L;
Dis_picture=Cue_arrow_L;
Cground=C_arrow_ground{2};
   if loc==1;
       draw_pic=Tar_picture;
   else
       draw_pic=Dis_picture;
   end 
elseif type==4
Tar_picture=Cue_arrow_L;
Dis_picture=Cue_arrow_R;
Cground=IC_arrow_ground{2};
   if loc==1;
       draw_pic=Tar_picture;
   else
       draw_pic=Dis_picture;
   end    
end
    for i=1:2*r
        for j=1:2*r
            Cground(i+o_x(loc),j+o_y(loc),:)=draw_pic(i,j,:);
           
        end
    end
    result(2,t)=loc;
 else
     loc=NO_TARGET_LOCATION;
    result(2,t)=loc;
   if type==1
     Cground=C_arrow_ground{1};
   elseif type==2
     Cground=IC_arrow_ground{1};
   elseif type==3
     Cground=C_arrow_ground{2};
   elseif type==4
     Cground=IC_arrow_ground{2};
   end    
end
   if type==1 || type==2
      result(3,t)=1;%R
  else
      result(3,t)=2;%L
  end
  if type==1 || type==3
      result(8,t)=1;%Congrouent
  else
      result(8,t)=2;%InCon
  end  
   

  
 target{t}=Cground;
    
end

%%%%%%%%%%%%%%% MakeTxtures
for i=1:TrialNum
    probe(i)=Screen('MakeTexture',w,target{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect',w,Black,wRect);
Screen('FillOval',w,[255 255 0], FixationRect);
Screen('DrawText',w,Text,20,20,[255 255 0]);
Screen('Flip',w);
%
BackGRect=Screen('Rect',att);
[touch, secs, keyCode] = KbCheck;
touch =0;

while ~(touch && (keyCode(TriggerKey)))
    [touch, secs, keyCode] = KbCheck;
end
if keyCode(EscapeKey)
    Screen('CloseAll');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% pre fixation
t0=GetSecs;
Screen('DrawTexture',w,att,BackGRect);
Screen('Flip',w);
while GetSecs<4.000+t0
    ;
end

%%%%%%%%%%%%%%%%% EyeLink recording start
trialInfo = repmat(struct('trial',[],'trialType',[],'targetLocation',[],'targetDirection',[],...
    'congruency',[],'trialStart',[],'targetOnset',[],'responseKey',[],'responseTime',[],'trialEnd',[]), 1, TrialNum);
Eyelink('Command', 'set_idle_mode');
Eyelink('Command', 'clear_screen %d', 0);
WaitSecs(0.05);
Eyelink('StartRecording');
Eyelink('Message', 'BLOCK_START %d', runNum);

%%%%%%%%%%%%%%%%% main
for trial=1:TrialNum
   %%  fixation ISI
    ISI_time=1;
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<t+ISI_time
        ;
    end

    trialType = trialTypeOrder(trial);
    targetLoc = result(2,trial);
    targetDir = result(3,trial);
    congruency = result(8,trial);
    trialStart = GetSecs;
    Eyelink('Message', 'TRIALID %d', trial);
    Eyelink('Message', 'TRIAL_START %d', trial);
    Eyelink('Message', 'TRIAL_TYPE %d', trialType);
    Eyelink('Message', 'TARGET_LOC %d', targetLoc);
    Eyelink('Message', 'TARGET_DIR %d', targetDir);
    Eyelink('Message', 'CONGRUENCY %d', congruency);

    result(4,trial)=0;
    result(5,trial)=NaN;
    %%  Target
    t_begin=GetSecs;
    Screen('DrawTexture',w,probe(trial),BackGRect);
    targetOnset=Screen('Flip',w);
    Eyelink('Message', 'TARGET_ONSET %d', trial);
    keyCode=zeros(1,256);
    keyIsDown=0;
    a=0;
    while GetSecs-t_begin<0.4
         [keyIsDown, secs, keyCode] = KbCheck;
         if  (~a)&&(keyCode(leftKey)||keyCode(rightKey)||keyCode(EscapeKey))
                    a=1;
                    if keyCode(rightKey)
                        result(4,trial)=1;
                    elseif keyCode(leftKey)
                        result(4,trial)=2;
                    end
                    if keyCode(EscapeKey)
                        Screen('Closeall');
                    end
                    result(5,trial)=GetSecs-t_begin;
                    Eyelink('Message', 'RESPONSE %d %d', trial, result(4,trial));
         end
       
    end

%%  response
if a==1
    b=1;
else
    b=0;
    keyCode=zeros(1,256);
    keyIsDown=0;
end
    tt=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);

  while GetSecs-tt<2.0000
        [keyIsDown, secs, keyCode] = KbCheck;
        if  (~b)&&(keyCode(leftKey)||keyCode(rightKey)||keyCode(EscapeKey))
            b=1;
            if keyCode(rightKey)
                result(4,trial)=1;
            elseif keyCode(leftKey)
                result(4,trial)=2;
            end
            if keyCode(EscapeKey)
                Screen('Closeall');
            end
            result(5,trial)=GetSecs-t_begin;
            Eyelink('Message', 'RESPONSE %d %d', trial, result(4,trial));
        end
        if b
            break;
        end
   end
   %%
    %%  ITI
    t=GetSecs;
    Screen('DrawTexture',w,att,BackGRect);
    Screen('Flip',w);
    while GetSecs<rand(1)*(1-0.5)+1.5+t
        
    end
    %%rest
    if rem(trial,rest)==0
        ae=floor(trial/rest);
        be=sprintf('%d',ae);
        Restcue=strcat('Please close your eyes and rest for a while!',be);
        Screen('FillRect',w,Black,wRect);
        Screen('DrawText',w,Restcue,1280/2-250,1024/2-8,[255 255 0]);
        Screen('Flip',w);
        touch =0;
        while ~(touch && (keyCode(TriggerKey)))
            [touch, secs, keyCode] = KbCheck;
        end
        if keyCode(EscapeKey)
            Screen('CloseAll');
        end
        t_rest=GetSecs;
        Screen('DrawTexture',w,att,BackGRect);
        Screen('Flip',w);
        while GetSecs<4.000+t_rest
            ;
        end
    end

    trialEnd = GetSecs;
    trialInfo(trial).trial = trial;
    trialInfo(trial).trialType = trialType;
    trialInfo(trial).targetLocation = targetLoc;
    trialInfo(trial).targetDirection = targetDir;
    trialInfo(trial).congruency = congruency;
    trialInfo(trial).trialStart = trialStart;
    trialInfo(trial).targetOnset = targetOnset;
    trialInfo(trial).responseKey = result(4,trial);
    trialInfo(trial).responseTime = result(5,trial);
    trialInfo(trial).trialEnd = trialEnd;
    Eyelink('Message', 'TRIAL_END %d', trial);
end
Eyelink('Message', 'BLOCK_END %d', runNum);
Eyelink('StopRecording');
Eyelink('CloseFile');
fprintf('Receiving data file ''%s''\n', edfFile );
status=Eyelink('ReceiveFile');
if status > 0
    fprintf('ReceiveFile status %d\n', status);
end
if 2==exist(edfFile, 'file')
    fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
end
%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sum_time=GetSecs-t0
ShowCursor;
Screen('CloseAll');
% ENDING
% cleaning up and sending file to your computer at the end of your
% experiment

Eyelink('Command' , 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');
%download data file
try
    fprintf('Receiving data file ''%s''\n', edfFile );
    status=Eyelink('ReceiveFile');
    if status > 0
        fprintf('ReceiveFile status %d\n', status);
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
    if 2==exist(edfFile, 'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
    end
catch
    fprintf('Problem receiving data file ''%s''\n', edfFile );
end
Eyelink('Shutdown');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PD0-PD4
pdMap=[10 11 22 33 44 11 22 33 44];
for trial=1:TrialNum
    if result(2,trial) ~= NO_TARGET_LOCATION
        result(6,trial)=pdMap(result(2,trial));
    end
end
%%%%%%%%%%%%%%%%%%%%%%% ACC
for trial=1:TrialNum
    if result(3,trial)==result(4,trial)
        result(7,trial)=1; %%%%% correct
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACC
vn0=0; vn1=0;vn2=0;vn3=0;vn4=0;
ivn0=0; ivn1=0;ivn2=0;ivn3=0;ivn4=0;
nvn=0;invn=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%RT
RTvn0=0;RTvn1=0;RTvn2=0;RTvn3=0;RTvn4=0;
RTivn0=0;RTivn1=0;RTivn2=0;RTivn3=0;RTivn4=0;
RTnvn=0;RTinvn=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
    if result(7,trial)==1
       if result(2,trial) ~= NO_TARGET_LOCATION
        if result(6,trial)==10   % PD=0
            if result(8,trial)==1
                vn0=vn0+1;
                RTvn0(vn0,1)=result(5,trial);
       
            elseif result(8,trial)==2
                ivn0=ivn0+1;
                RTivn0(ivn0,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==11   % PD=1
            if result(8,trial)==1
                vn1=vn1+1;
                RTvn1(vn1,1)=result(5,trial);
         
            elseif result(8,trial)==2
                ivn1=ivn1+1;
                RTivn1(ivn1,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==22   % PD=2
            if result(8,trial)==1
                vn2=vn2+1;
                RTvn2(vn2,1)=result(5,trial);
            elseif result(8,trial)==2
                ivn2=ivn2+1;
                RTivn2(ivn2,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==33   % PD=3
            if result(8,trial)==1
                vn3=vn3+1;
                RTvn3(vn3,1)=result(5,trial);
            elseif result(8,trial)==2
                ivn3=ivn3+1;
                RTivn3(ivn3,1)=result(5,trial);
            end
        end
        %%%%%%%%%%%%
        if result(6,trial)==44   % PD=4
            if result(8,trial)==1
                vn4=vn4+1;
                RTvn4(vn4,1)=result(5,trial);             
            elseif result(8,trial)==2
                ivn4=ivn4+1;
                RTivn4(ivn4,1)=result(5,trial);
            end
        end
       elseif result(2,trial) == NO_TARGET_LOCATION
           if result(8,trial)==1
                nvn=nvn+1;
                RTnvn(nvn,1)=result(5,trial);             
            elseif result(8,trial)==2
                invn=invn+1;
                RTinvn(invn,1)=result(5,trial);
            end
    end
    end
end
RT0=mean(RTvn0);RT1=mean(RTvn1);RT2=mean(RTvn2);RT3=mean(RTvn3);RT4=mean(RTvn4);
NRT=mean(RTnvn);
iRT0=mean(RTivn0);iRT1=mean(RTivn1);iRT2=mean(RTivn2);iRT3=mean(RTivn3);iRT4=mean(RTivn4);
iNRT=mean(RTinvn);

AE0=(NRT-RT0)*1000;
AE1=(NRT-RT1)*1000;
AE2=(NRT-RT2)*1000;
AE3=(NRT-RT3)*1000;
AE4=(NRT-RT4)*1000;

iAE0=(iNRT-iRT0)*1000;
iAE1=(iNRT-iRT1)*1000;
iAE2=(iNRT-iRT2)*1000;
iAE3=(iNRT-iRT3)*1000;
iAE4=(iNRT-iRT4)*1000;

O_AE0=(RT0)*1000;
O_AE1=(RT1)*1000;
O_AE2=(RT2)*1000;
O_AE3=(RT3)*1000;
O_AE4=(RT4)*1000;
O_NAE=(NRT)*1000;

O_iAE0=(iRT0)*1000;
O_iAE1=(iRT1)*1000;
O_iAE2=(iRT2)*1000;
O_iAE3=(iRT3)*1000;
O_iAE4=(iRT4)*1000;
O_iNAE=(iNRT)*1000;

AE_sum=[AE0 AE1 AE2 AE3 AE4];
iAE_sum=[iAE0 iAE1 iAE2 iAE3 iAE4];

O_AE_sum=[O_AE0 O_AE1 O_AE2 O_AE3 O_AE4 O_NAE];
O_iAE_sum=[O_iAE0 O_iAE1 O_iAE2 O_iAE3 O_iAE4 O_iNAE];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v0=0; v1=0;v2=0;v3=0;v4=0;
nv=0;
iv0=0; iv1=0;iv2=0;iv3=0;iv4=0;
inv=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for trial=1:TrialNum
    %%%%%%%%%%%%%%%%%%%%%%
   if result(2,trial) ~= NO_TARGET_LOCATION
    if result(6,trial)==10
        if result(8,trial)==1
            v0=v0+result(7,trial);     
        
        %%%%
        elseif result(8,trial)==2
            iv0=iv0+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==11
        if result(8,trial)==1
            v1=v1+result(7,trial);       
       
        %%%%
        elseif result(8,trial)==2
            iv1=iv1+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==22
        if result(8,trial)==1
            v2=v2+result(7,trial);
        
        elseif result(8,trial)==2
            iv2=iv2+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==33
        if result(8,trial)==1
            v3=v3+result(7,trial);
        
        %%%%
        elseif result(8,trial)==2
            iv3=iv3+result(7,trial);
        end
    end
    %%%%
    if result(6,trial)==44
        if result(8,trial)==1
            v4=v4+result(7,trial);         
        
        %%%%
        elseif result(8,trial)==2
            iv4=iv4+result(7,trial);
        end
    end
  elseif result(2,trial) == NO_TARGET_LOCATION
        if result(8,trial)==1
            nv=nv+result(7,trial);         
        
        %%%%
        elseif result(8,trial)==2
            inv=inv+result(7,trial);
        end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ACC
trialsPerPD=TrialNum/15;
trialsNoCue=TrialNum/6;
VACC_PD0=v0/trialsPerPD*100;
VACC_PD1=v1/trialsPerPD*100;
VACC_PD2=v2/trialsPerPD*100;
VACC_PD3=v3/trialsPerPD*100;
VACC_PD4=v4/trialsPerPD*100;
VACCM=(VACC_PD0+VACC_PD1+VACC_PD2+VACC_PD3+VACC_PD4)/5;
NVACC=nv/trialsNoCue*100;

IVACC_PD0=iv0/trialsPerPD*100;
IVACC_PD1=iv1/trialsPerPD*100;
IVACC_PD2=iv2/trialsPerPD*100;
IVACC_PD3=iv3/trialsPerPD*100;
IVACC_PD4=iv4/trialsPerPD*100;
IVACCM=(IVACC_PD0+IVACC_PD1+IVACC_PD2+IVACC_PD3+IVACC_PD4)/5;
NIVACC=inv/trialsNoCue*100;

ACCM=[VACC_PD0 VACC_PD1 VACC_PD2 VACC_PD3 VACC_PD4;IVACC_PD0 IVACC_PD1 IVACC_PD2 IVACC_PD3 IVACC_PD4; VACC_PD0-IVACC_PD0 VACC_PD1-IVACC_PD1 VACC_PD2-IVACC_PD2 VACC_PD3-IVACC_PD3 VACC_PD4-IVACC_PD4];
ALL_ACC=sum(result(7,:))/TrialNum*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Block=num2str(runNum);
FileName=['GaMHT_Bar' '_' ID '_' Block];
sts.All_ACC=ALL_ACC;
sts.AE=AE_sum;
sts.iAE=iAE_sum;
sts.O_AE=O_AE_sum;
sts.O_iAE=O_iAE_sum;
sts.VACC=VACCM;
sts.IVACCM=IVACCM;
sts.NVACC=NVACC;
sts.NIVACCM=NIVACC;
sts.result=result;
Name=['GaAnalysis_result' '_' ID '_' Block];

eyeData.edfFile = edfFile;
eyeData.trialInfo = trialInfo;
eyeData.trialTypeOrder = trialTypeOrder;

save (Name,'sts');
save(FileName, 'result','eyeData');
