
clear all

sca;

addpath('spatialfunctions');  % search the spatialfunctions directory for scripts and functions

% variable declarations
global MainWindow DATA 
global keyCounterbal
global distract_col colourName
global white black gray yellow red
global bigMultiplier smallMultiplier
global zeroPayRT oneMSvalue nf
global datafilename
global scrWidth scrHeight scrCentre  % Andy
global minPayment maxPayment totalPay
global currentLevel currentMedal
global numMedals medalRank
global stim_size stim_pen

global realVersion reversalVersion

realVersion = true;
% for the practical class we are going to ask them to input this manually
%reversalVersion = false; %if set to false then phase 3 is extinction, if set to true then phase 3 is reversal of the colour-reward contingencies;

clc;
commandwindow;

nf = java.text.DecimalFormat;  % this displays the thousands separator and decimals according the the computers' Locale settings 

if realVersion
    screenNum = 0;
    Screen('Preference', 'SkipSyncTests', 2);      % Enables the Psychtoolbox calibrations
else
    screenNum = 0;
    Screen('Preference', 'SkipSyncTests', 2);      % Skips the Psychtoolbox calibrations
    fprintf('\n\nEXPERIMENT IS BEING RUN IN DEBUGGING MODE!!! IF YOU ARE RUNNING A ''REAL'' EXPT, QUIT AND CHANGE realVersion TO true\n\n');

end

KbName('UnifyKeyNames');


% set trial values
zeroPayRT = 1500;       % 1000
fullPayRT = 500;        % 500, I think this is unused
oneMSvalue = 0.1;
bigMultiplier = 10;    % Points multiplier for trials with high-value distractor
smallMultiplier = 1;   % Points multiplier for trials with low-value distractor
totalPay = 0; %this is now global as we need to pass it from session 2 to session 3.

keyCounterbal = 1;

minPayment = 6;     % Minimum amount that will be paid to participants (in dollars)
maxPayment = 15;     % Maximum amount that will be paid to participants (in dollars)
exchangeRate = 4000;     % Final points total is divided by this amount to give earnings (in dollars)

currentLevel = 0;   % Start at level 0 (for medals etc)
currentMedal = 0;   % Start with no medals

numMedals = 6;
medalRank = {'BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND', 'ELITE'};

stim_size = 92;     % 92 Size of stimuli
stim_pen = 8;      % Pen width of stimuli

if exist('VMAC_data', 'dir') == 0
    mkdir('VMAC_data');
end

% generate a random seed using the clock, then use it to seed the random
% number generator. In this version we will use the randSeed as pp number

rng('shuffle');
randSeed = randi(80000);

rng(randSeed);

date_time = datestr(now,'mmddyy_HHMMSS');

if realVersion
    
    inputError = 1;
    
    while inputError == 1
        inputError = 0;
        condition = input('Check with tutor which condition (1 or 2) and then press enter  ---> ');
        
        if condition == 1
            reversalVersion = false;
        else
            reversalVersion = true;
        end
        
    end
    p_number = randSeed;    
    
%     inputError = 1;
%     
%     while inputError == 1
%         inputError = 0;
        
        %p_number = input('Participant number  ---> '); %generated randomly
        %above
        
        datafilename = ['VMAC_data\VMAC_dataP', num2str(p_number), '_', date_time, '.mat'];
        
        if exist(datafilename, 'file') == 2
            disp(['Data for participant ', num2str(p_number),' already exist'])
            inputError = 1;
        end
        
    %end
        
        
    colBalance = randsample(4,1); % randomly select the colBalance
%     colBalance = 0;
%     while colBalance < 1 || colBalance > 4
%         colBalance = input('Counterbalance (1-4) ---> ');
%         if isempty(colBalance); colBalance = 0; end
%     end
    
    p_age = input('Please enter your age and then press Enter ---> ');
    p_sex = 'a';
    while ~strcmpi(p_sex, 'M') && ~strcmpi(p_sex, 'F') && ~strcmpi(p_sex, 'O')
        p_sex = input('Please enter your gender (M/F/O) and then press Enter ---> ', 's');
        if isempty(p_sex); p_sex = 'a'; end
    end
    
    p_hand = 'a';
    while ~strcmpi(p_hand, 'R') && ~strcmpi(p_hand, 'L')
        p_hand = input('Please indicate handedness (R/L) and then press Enter  ---> ','s');
        if isempty(p_hand); p_hand = 'a'; end
    end
        
    
else
    
    reversalVersion = false; %if set to false then phase 3 is extinction, if set to true then phase 3 is reversal of the colour-reward contingencies;
    p_number = 499;
    colBalance = 3;
    p_sex = 'm';
    p_age = 123;
    p_hand = 'r';
    datafilename = ['VMAC_data\VMAC_dataP', num2str(p_number), '_', date_time, '.mat'];
    
end

DATA.subject = p_number;
DATA.version_Rev1Ext0 = reversalVersion;
DATA.colBalance = colBalance;
DATA.age = p_age;
DATA.sex = p_sex;
DATA.hand = p_hand;
DATA.start_time = datestr(now,0);
DATA.rSeed = randSeed;
startSecs = GetSecs;


if realVersion
    MainWindow = Screen(0, 'OpenWindow', black);
else
    MainWindow = Screen(screenNum, 'OpenWindow', black, [0, 0, 1920, 1080]);
end

Screen('BlendFunction', MainWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');      % This allows for transparent backgrounds when we show images (by controlling alpha values), which is important for making things look pretty.


% Get screen resolution, and find location of centre of screen
[scrWidth, scrHeight] = Screen('WindowSize', MainWindow);
res = [scrWidth scrHeight];
scrCentre = res / 2;


% set colors
white = [255, 255, 255];
black = [0, 0, 0];
gray = [70, 70, 70];
orange = [193, 95, 30];
green = [54, 145, 65];
blue = [37, 141, 165];
pink = [193, 87, 135];
yellow = [255, 255, 0];
red = [255, 0, 0];


DATA.frameRate = round(Screen(MainWindow, 'FrameRate'));

HideCursor;

Screen('TextFont', MainWindow, 'Segoe UI');

Screen('TextSize', MainWindow, 34);

Screen('FillRect',MainWindow, black);

distract_col = zeros(5,3);

distract_col(5,:) = yellow;       % Practice colour

if colBalance == 1
    distract_col(1,:) = green;      % High-value distractor colour
    distract_col(2,:) = pink;      % Low-value distractor colour
elseif colBalance == 2
    distract_col(1,:) = green;
    distract_col(2,:) = pink;
elseif colBalance == 3
     distract_col(1,:) = green;
     distract_col(2,:) = pink;
 elseif colBalance == 4
     distract_col(1,:) = green;
     distract_col(2,:) = pink;
end

        
distract_col(3,:) = gray;
distract_col(4,:) = gray;



colourName = cell(2,1);

for ii = 1 : length(colourName)
    if distract_col(ii,:) == orange
        colourName(ii) = {'ORANGE'};
    elseif distract_col(ii,:) == green
        colourName(ii) = {'GREEN'};
    elseif distract_col(ii,:) == blue
        colourName(ii) = {'BLUE'};
    elseif distract_col(ii,:) == pink
        colourName(ii) = {'PINK'};
    elseif distract_col(ii,:) == yellow
        colourName(ii) = {'YELLOW'};
    elseif distract_col(ii,:) == gray
        colourName(ii) = {'GREY'};
    end
end




if realVersion        % MIKE: I've shuffled this round a little bit so you don't have to give consent every time when debugging

    granted = informedconsent;
    HideCursor;

    if granted ==1
        initialInstructionsTestSpatial;
        runTrialsSpatial(1);     % Practice phase
        totalPay=0;
        exptInstructionsTestSpatial(1);
        runTrialsSpatial(2);     % Reward Phase
        showExtinctionReversalInstructionsSpatial;
        runTrialsSpatial(3);    % Neutral Phase
        exptInstructionsTestSpatial(2);
        runTrialsSpatial(4);    % Penalty Phase
        showExtinctionReversalInstructionsSpatial;
        runTrialsSpatial(3);    % Neutral Phase
        
    end
    
else
    granted = 1;

    initialInstructionsTestSpatial;
    runTrialsSpatial(1);
    totalPay=0;
    exptInstructionsTestSpatial;
    runTrialsSpatial(2);
    showExtinctionReversalInstructionsSpatial;
    runTrialsSpatial(3);

    
end



%No payment for this lot!!

%bonusPayment = VMACtotalPoints / exchangeRate;      % Get amount in dollars
%bonusPayment = ceil(bonusPayment * 10) / 10;        % ... round this value UP to nearest 10 cents

% set floor and ceiling
%if bonusPayment > maxPayment
%    bonusPayment = maxPayment;
%elseif bonusPayment < minPayment     % This is here in case there are any very unlucky dolts
%    bonusPayment = minPayment;
%end

DATA.informedconsent = granted;

%DATA.bonusPayment = bonusPayment;
DATA.end_time = datestr(now,0);
DATA.exptDuration = GetSecs - startSecs;


% store bonus in .csv file
%fid1 = fopen('VMAC_data\_TotalBonus_summary.csv', 'a');
%fprintf(fid1,'%d,%d,%f\n', p_number, VMACtotalPoints, bonusPayment);
%fclose(fid1);

Screen('TextFont', MainWindow, 'Segoe UI');



% final screen
if granted == 1
    DATA.VMACtotalPoints = totalPay;
    
    
    Screen('TextSize', MainWindow, 58);
    Screen('TextStyle', MainWindow, 1);

    DrawFormattedText(MainWindow, ['TASK COMPLETE\nYou earned ', separatethousands(totalPay, ','), ' points. Well done!\n'], 'center', 150, white, [], [], [], 1.8);
    
    if currentMedal > 0
        tempStr = char(medalRank(currentMedal));
        medalMatrix = imread(['spatialfunctions\medals\medal', num2str(currentMedal),'.jpg'], 'jpg');
        medalRect = [0,0,size(medalMatrix, 2), size(medalMatrix, 1)];
        Screen('PutImage', MainWindow, medalMatrix, CenterRectOnPoint(medalRect, scrCentre(1), 620)); % put medal image on screen
    else
        tempStr = 'NONE';
    end
    
    Screen('TextSize', MainWindow, 54);

    DrawFormattedText(MainWindow, ['Your final rank is:  ', tempStr], 'center', 470 , yellow);
    
    Screen('TextStyle', MainWindow, 0);
    DrawFormattedText(MainWindow, 'Please press Esc to continue!', 'center', 940, white);
    
else
    DrawFormattedText(MainWindow, 'You did not give consent to participate. \n\nPlease press Esc to continue!', 'center', 'center' , white, [], [], [], 1.3);
end


save(datafilename, 'DATA');
save ('Inquisitinput.txt', 'p_number' ,'-ascii');
save ('InformedConsent.txt', 'granted', '-ascii');

Screen(MainWindow, 'Flip');

RestrictKeysForKbCheck(KbName('ESCAPE'));   % Only accept escape key to quit
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys


rmpath('spatialfunctions');

Screen('Preference', 'SkipSyncTests',0);

sca;

clear all;
