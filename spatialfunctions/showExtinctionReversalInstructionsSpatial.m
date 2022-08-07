function showExtinctionReversalInstructionsSpatial


global MainWindow scrCentre 
global distract_col colourName
global white black gray yellow
global bigMultiplier
global stim_size stim_pen
global reversalVersion

if reversalVersion % show reversal instructions 
    show_ReversalInstructions()
else
    showExtinctionInstructionsSpatial() % show extinction instructions 
end
%{
initialInstructTest_iti= 1;

ansButtonWidth = 800;
ansButtonHeight = 100;
ansButtonTop = 400;
ansButtonDisplacement = 150;

ansButtonWin = zeros(2,1); %only need two answer options

 numAnswerOptions =[2,2];
 if reversalVersion
     numofQuestions = 2;
     ques = {['From now on, what type of trial will it be if the circle in the display is coloured ' char(colourName(1)) '?'], ['From now on, what type of trial will it be if the circle in the display is coloured ' char(colourName(2)) '?']};
     answers = {[num2str(bigMultiplier) ' x Bonus Trial'], 'No Bonus Trial'}; %n.b. for the first question the 2nd answer is correct, for the second question the 1st answer is correct
 else
     numofQuestions = 1;
     ques = {'What will be different about the final phase of the game?'};
     answers = {'Nothing has changed', 'I will no longer win (or lose) points \nfor correct (or incorrect) responses'};
 end


    
for question = 1:numofQuestions
     
    for i = 1 : numAnswerOptions(question)
        ansButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 ansButtonWidth ansButtonHeight]);
        Screen('FillRect', ansButtonWin(i), gray);
        Screen('TextSize', ansButtonWin(i), 30);
        Screen('TextFont', ansButtonWin(i), 'Calibri');
        DrawFormattedText(ansButtonWin(i), char(answers(i)), 'center', 'center', yellow);
    end
    
    Screen('TextFont', MainWindow, 'Segoe UI');
    Screen('TextSize', MainWindow, 34);
   
    ansButtonRect = zeros(2,4);
    ansButtonRect(1,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop   scrCentre(1) + ansButtonWidth/2   ansButtonTop + ansButtonHeight];
    ansButtonRect(2,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop + ansButtonDisplacement    scrCentre(1) + ansButtonWidth/2    ansButtonTop + ansButtonDisplacement + ansButtonHeight];
 
    
    mouseInstruct = 'Use the mouse to select the correct answer';
    
    ShowCursor('Arrow');
    
    %DRAW THE QUESTION
    [~,~,instr2boundsRect] = DrawFormattedText(MainWindow, char(ques(question)), 'center', 100, white, 50, [], [], 1.5);
    DrawFormattedText(MainWindow, mouseInstruct, 'center', ansButtonTop - 50, white, 50, [], [], 1.5);
    
    circle_top = 200;	% Position of top of sample circle
    
    if reversalVersion
        if question==1
            Screen('FrameOval', MainWindow, distract_col(1,1:3), [scrCentre(1) - stim_size / 2    circle_top   scrCentre(1) + stim_size / 2    circle_top + stim_size], stim_pen, stim_pen);
        elseif question == 2
            Screen('FrameOval', MainWindow, distract_col(2,1:3), [scrCentre(1) - stim_size / 2    circle_top   scrCentre(1) + stim_size / 2    circle_top + stim_size], stim_pen, stim_pen);
        end
    end
    
    % show answers
    for i = 1 : numAnswerOptions(question)
        Screen('DrawTexture', MainWindow, ansButtonWin(i), [], ansButtonRect(i,:));
    end
    
    Screen('Flip', MainWindow, [], 1);
    
    correct = 0;
    while correct == 0
        
        clickedansButton = 0;
        while clickedansButton == 0
            [~, x, y, ~] = GetClicks(MainWindow, 0);
            for i = 1 : 2
                if x > ansButtonRect(i,1) && x < ansButtonRect(i,3) && y > ansButtonRect(i,2) && y < ansButtonRect(i,4)
                    clickedansButton = i;
                end
            end
        end
        
        if (question == 1 && clickedansButton == 2)||(question == 2 && clickedansButton == 1)
            feedbackStr = 'Yes that is correct';
            correct = 1;
            FBwait = 2;
        else
            feedbackStr = 'No that is incorrect, try again';
            FBwait = 1;
        end
        
        [~,~,instr2boundsRect] = DrawFormattedText(MainWindow, feedbackStr, 'center', ansButtonTop + ansButtonDisplacement*3, white);
        Screen('Flip', MainWindow, [], 1);
        WaitSecs(FBwait);
        
        Screen('FillRect', MainWindow, black, instr2boundsRect + [-10 -10 10 10]);    % Cover up feedback string
        Screen('Flip', MainWindow, [], 1);
    end
    
    Screen('FillRect',MainWindow, black);
    Screen('Flip', MainWindow);     % Clear screen
    WaitSecs(initialInstructTest_iti);
        
end % END OF QUESTION LOOP


HideCursor;
 
for i = 1:2
    Screen('Close', ansButtonWin(i));
end
%}
HideCursor;
DrawFormattedText(MainWindow, 'You are now ready for your final challenge!!\n\nGood Luck!!\n\nPlease place your fingers on the C and M keys\nand press the spacebar to begin', 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys

Screen('Flip', MainWindow);

end


function show_ReversalInstructions

global MainWindow scrCentre black white yellow
global distract_col bigMultiplier
global colourName
global realVersion

textWrap = 86;
textTop = 120;
textLeft = 180;

insStr = 'Something crazy has happened!\nThe relationships between the coloured circles and the bonus trials have changed!';

instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instrWin, 40);
Screen('TextStyle', instrWin, 1);
Screen('TextFont', instrWin, 'Segoe UI');


DrawFormattedText(instrWin, insStr, 'center', textTop, yellow, [], [], [], 1.5);


Screen('DrawTexture', MainWindow, instrWin);

instrOffset = 500;
circSize = 150;
circTop = 360;

circleRect(1,:) = [scrCentre(1) - instrOffset    circTop    scrCentre(1) - instrOffset + circSize    circTop + circSize];
circleRect(2,:) = [scrCentre(1) + instrOffset - circSize circTop scrCentre(1) + instrOffset circTop + circSize];


highString = ['From now on, if ' aOrAn(char(colourName(2))) ' ' char(colourName(2)) ' circle is in the display, the trial WILL be a ' num2str(bigMultiplier) 'x BONUS TRIAL.']; %here the colournumber has reversed
lowString = ['From now on, if ' aOrAn(char(colourName(1))) ' ' char(colourName(1)) ' circle is in the display, the trial WILL NOT be a ' num2str(bigMultiplier) 'x BONUS TRIAL.'];  %here the colournumber has reversed

Screen('FrameOval', instrWin, distract_col(2,1:3), circleRect(1,:), 10, 10); %here the colournumber has reversed too.
Screen('FrameOval', instrWin, distract_col(1,1:3), circleRect(2,:), 10, 10);


tempInt = circTop + 340;

textWinRect = [0, 0, 600, 300];
textWin = Screen('OpenOffscreenWindow', MainWindow, black, textWinRect);
Screen('TextSize', textWin, 40);
Screen('TextStyle', textWin, 1);
Screen('TextFont', textWin, 'Segoe UI');

DrawFormattedText(textWin, highString, 'center', [], white, 30, [], [], 1.4);
Screen('DrawTexture', instrWin, textWin, [], CenterRectOnPoint(textWinRect, scrCentre(1) - instrOffset + circSize/2, tempInt));

Screen('FillRect', textWin, black);

DrawFormattedText(textWin, lowString, 'center', [], white, 30, [], [], 1.4);
Screen('DrawTexture', instrWin, textWin, [], CenterRectOnPoint(textWinRect, scrCentre(1) + instrOffset - circSize/2, tempInt));

Screen('Close', textWin);

Screen('DrawTexture', MainWindow, instrWin);
Screen('Flip', MainWindow);

if realVersion
    WaitSecs(8);
end
%{
Screen('TextSize', instrWin, 28);
DrawFormattedText(instrWin, 'Press space to begin','center', 950, yellow);

Screen('DrawTexture', MainWindow, instrWin);
Screen('Flip', MainWindow);

Screen('TextSize', MainWindow, 34);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instrWin);
%}
end

function out = aOrAn(colour)
    if strcmp(colour,'ORANGE')
        out = 'an';
    else
        out = 'a';
    end
end

function showExtinctionInstructionsSpatial

global MainWindow
global black white yellow
global realVersion


instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextFont', instrWin, 'Segoe UI');
Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 1);

instrString1a = 'You''re doing a great job!';
instrString1b = 'FROM NOW ON, THERE ARE NO MORE POINTS AVAILABLE!\nThis means that you will not win (or lose) any points for the rest of the game.';
instrString1c = '\n\nNevertheless, you should carry on responding to the orientation of the line within the diamond as quickly and accurately as possible.';
instrString1d = '\n\nPress space to begin';

Screen('TextSize', instrWin, 40);
[~, ny, ~] = DrawFormattedText(instrWin, instrString1a, 'center', 150, white, 90);
Screen('TextSize', instrWin, 48);
Screen('TextStyle', instrWin, 1);
[~, ny, ~] = DrawFormattedText(instrWin, instrString1b, 'center', ny+160, yellow, 60, [], [], 1.3);
Screen('TextSize', instrWin, 40);
Screen('TextStyle', instrWin, 0);
[~, ny, ~] = DrawFormattedText(instrWin, instrString1c, 'center', ny+50, white, 60, [], [], 1.2);
Screen('DrawTexture', MainWindow, instrWin);
Screen('Flip', MainWindow);

if realVersion
    WaitSecs(1);
end

[~, ny, ~] = DrawFormattedText(instrWin, instrString1d, 'center', ny + 180, white, 60, [], [], 1.2);
Screen('DrawTexture', MainWindow, instrWin);
Screen('Flip', MainWindow);


RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);

Screen('Close', instrWin);

end
