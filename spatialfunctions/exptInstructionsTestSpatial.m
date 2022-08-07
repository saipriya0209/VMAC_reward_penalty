function exptInstructionsTestSpatial(exptBlock)


global MainWindow scrCentre scrHeight scrWidth
global distract_col colourName
global white black gray yellow red
global bigMultiplier
global stim_size stim_pen
if exptBlock ==1
    exptInstructionsSpatial();
end
%{
initialInstructTest_iti= 1;

ansButtonWidth = 1000;
ansButtonHeight = 100;
ansButtonTop = 400;
ansButtonDisplacement = 150;

ansButtonWin = zeros(4,1);

 numAnswerOptions =[3,2,2,3];
 ques = {'How do you earn points in this game?', ['What type of trial will it be if the circle in the display is coloured ' char(colourName(1)) '?'], ['What type of trial will it be if the circle in the display is coloured ' char(colourName(2)) '?'],'What happens when you make an incorrect response to the line inside the diamond?'};
%  answersQ1 = char('You receive 10 points every time you make a correct \nresponse to the line inside the diamond','The faster that you make a correct response \nto the line inside the diamond the more points you earn','You do not earn points during this part of the experiment');
%  answersQ4 = char('You lose 10 points every time you make an incorrect response','You do not lose any points for making an incorrect response','    You lose the amount of points that you would otherwise have won    ');
%  answersQ2Q3 = char ([num2str(bigMultiplier) ' x Bonus Trial'], 'No Bonus Trial');
 
 answersQ1 = {'You receive 10 points every time you make a correct\nresponse to the line inside the diamond','The faster that you make a correct response\nto the line inside the diamond the more points you earn','You do not earn points during this part of the experiment'};
 answersQ4 = {'You lose 10 points every time you make an incorrect response', 'You do not lose any points for making an incorrect response','You lose the amount of points that you would otherwise have won'};
 answersQ2Q3 = {[num2str(bigMultiplier) ' x Bonus Trial'], 'No Bonus Trial'};

 %n.b. for the first question the 2nd answer is correct, for the second question the third answer is correct, 3rd Q = 1st Answer and vice versa for q4.

    
for question = 1:4
     
    for i = 1 : numAnswerOptions(question)
        ansButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 ansButtonWidth ansButtonHeight]);
        Screen('FillRect', ansButtonWin(i), gray);
        Screen('TextSize', ansButtonWin(i), 30);
        Screen('TextFont', ansButtonWin(i), 'Calibri');
        if question == 1
            DrawFormattedText(ansButtonWin(i), char(answersQ1(i)), 'center', 'center', yellow);
        elseif question == 4
            DrawFormattedText(ansButtonWin(i), char(answersQ4(i)), 'center', 'center', yellow);
        else
            DrawFormattedText(ansButtonWin(i), char(answersQ2Q3(i)), 'center', 'center', yellow);
        end
    end
    
          
    ansButtonRect = zeros(3,4);
    ansButtonRect(1,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop   scrCentre(1) + ansButtonWidth/2   ansButtonTop + ansButtonHeight];
    ansButtonRect(2,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop + ansButtonDisplacement    scrCentre(1) + ansButtonWidth/2    ansButtonTop + ansButtonDisplacement + ansButtonHeight];
    ansButtonRect(3,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop + ansButtonDisplacement*2    scrCentre(1) + ansButtonWidth/2   ansButtonTop + ansButtonDisplacement*2 + ansButtonHeight];

    Screen('TextFont', MainWindow, 'Segoe UI');
    Screen('TextSize', MainWindow, 34);
    
    mouseInstruct = 'Use the mouse to select the correct answer';
    
    ShowCursor('Arrow');
    
    %DRAW THE QUESTION
    [~,~,instr2boundsRect] = DrawFormattedText(MainWindow, char(ques(question)), 'center', 100, white, 50, [], [], 1.5);
    DrawFormattedText(MainWindow, mouseInstruct, 'center', ansButtonTop - 50, white, 50, [], [], 1.5);

    
    circle_top = 200;	% Position of top of sample circle
    
    if question==2 
    Screen('FrameOval', MainWindow, distract_col(1,1:3), [scrCentre(1) - stim_size / 2    circle_top   scrCentre(1) + stim_size / 2    circle_top + stim_size], stim_pen, stim_pen);
    elseif question == 3
    Screen('FrameOval', MainWindow, distract_col(2,1:3), [scrCentre(1) - stim_size / 2    circle_top   scrCentre(1) + stim_size / 2    circle_top + stim_size], stim_pen, stim_pen);
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
            for i = 1 : 3
                if x > ansButtonRect(i,1) && x < ansButtonRect(i,3) && y > ansButtonRect(i,2) && y < ansButtonRect(i,4)
                    clickedansButton = i;
                end
            end
        end
        
        if (question == 1 && clickedansButton == 2)||(question == 4 && clickedansButton == 3)||(question == 2 && clickedansButton == 1)||(question == 3 && clickedansButton == 2)
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

%HideCursor;
 
for i = 1:3
    Screen('Close', ansButtonWin(i));
end
%}
HideCursor;
if exptBlock == 1
    DrawFormattedText(MainWindow, 'You are now ready to begin the game!! \n\nGood Luck!! \n\nPlease place your fingers on the C and M keys\nand press the spacebar to begin', 'center', 'center', white, [], [], [], 1.5);
else
    DrawFormattedText(MainWindow, 'This is a penalty block. If you enter the wrong key then you loose the points you would have other wise gained.\n\n You will not receive points for correct keys in this round \n\nGood Luck!! \n\nPlease place your fingers on the C and M keys\nand press the spacebar to begin', 'center', 'center', white, [], [], [], 1.5);
end

Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys

Screen('Flip', MainWindow);

end



function exptInstructionsSpatial

global MainWindow white
global oneMSvalue zeroPayRT
global bigMultiplier
global minPayment maxPayment
global realVersion


instructStr1 = 'The rest of this game is similar to the trials you have just completed. On each trial, you should respond to the line that is contained inside the DIAMOND shape.\n\nIf the line is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
instructStr2 = 'From now on, you will be able to earn points for correct responses, depending on how fast you respond. As you earn points, your Expertise Level will increase. For every 10 Expertise Levels you increase, you will unlock a medal.\n\nOnly around 10% of participants will unlock the ELITE medal - can you?';
instructStr3 = ['The faster you respond on each trial, the more points you will earn.\n\nFor every 100ms that your response time (RT) is faster than ', num2str(zeroPayRT), 'ms, you will\nearn ', num2str(100*oneMSvalue), ' points.\n\nHowever, if you make an error you will LOSE the corresponding number of points.'];
instructStr4 = ['IMPORTANT: Some of the trials will be BONUS trials! On these trials the amount that you win or lose will be multiplied by ', num2str(bigMultiplier),'.\n\n']; 
instructStr5 = 'After each response you will be told how many points you won or lost. After each block of trials, you will be told if your Expertise Level has increased, and if you have unlocked a new medal.\n\nRemember, the more points you win, the more medals you will unlock!';

if realVersion
    show_Instructions(1, instructStr1, 1);
    show_Instructions(2, instructStr2, 1);
    show_Instructions(3, instructStr3, 1);
    show_Instructions(4, instructStr4, 1);
    show_Instructions(5, instructStr5, 1);
else
    show_Instructions(1, instructStr1, 1);
    show_Instructions(2, instructStr2, 1);
    show_Instructions(3, instructStr3, 1);
    show_Instructions(4, instructStr4, 1);
    show_Instructions(5, instructStr5, 1);
end

%{
Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 34);

DrawFormattedText(MainWindow, 'Press space to begin', 'center', 'center' , white);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);
Screen('Flip', MainWindow);
%}
RestrictKeysForKbCheck([]); % Re-enable all keys

end


function show_Instructions(instrTrial, insStr, instrPause)

global MainWindow scrCentre black white yellow red
global distract_col bigMultiplier
global colourName

textWrap = 86;
textTop = 120;
textLeft = 180;

Screen('TextFont', MainWindow, 'Segoe UI');
Screen('TextSize', MainWindow, 34);

instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextSize', instrWin, 42);
Screen('TextStyle', instrWin, 0);
Screen('TextFont', instrWin, 'Segoe UI');

if instrTrial == 4
    Screen('TextStyle', instrWin, 1);
    DrawFormattedText(instrWin, insStr, textLeft, textTop, yellow, 75, [], [], 1.5);
    Screen('TextStyle', instrWin, 0);
else
    DrawFormattedText(instrWin, insStr, textLeft, textTop, white, textWrap, [], [], 1.5);
end



if instrTrial == 2
    medalMatrix = imread(['spatialfunctions\medals\medalDisplay.jpg'], 'jpg');
    medalRect = [0,0,size(medalMatrix, 2), size(medalMatrix, 1)];
    Screen('PutImage', instrWin, medalMatrix, CenterRectOnPoint(medalRect, scrCentre(1), 650)); % put medal image on screen
    
end

if instrTrial == 4
    extraStr = ['So you will earn much more for correct responses on "',num2str(bigMultiplier), ' x bonus" trials than on standard trials.'];
    DrawFormattedText(instrWin, extraStr, textLeft, 280, white, textWrap, [], [], 1.5);

    
    instrOffset = 500;
    circSize = 150;
    circTop = 470;
    
    circleRect(1,:) = [scrCentre(1) - instrOffset    circTop    scrCentre(1) - instrOffset + circSize    circTop + circSize];
    circleRect(2,:) = [scrCentre(1) + instrOffset - circSize circTop scrCentre(1) + instrOffset circTop + circSize];

    highString = ['If ' aOrAn(char(colourName(1))) ' ' char(colourName(1)) ' circle is in the display, the trial WILL be a ' num2str(bigMultiplier) 'x BONUS TRIAL.'];
    lowString = ['If ' aOrAn(char(colourName(2))) ' ' char(colourName(2)) ' circle is in the display, the trial WILL NOT be a ' num2str(bigMultiplier) 'x BONUS TRIAL.'];
    
    Screen('FrameOval', instrWin, distract_col(1,1:3), circleRect(1,:), 10, 10);
    Screen('FrameOval', instrWin, distract_col(2,1:3), circleRect(2,:), 10, 10);

    
    tempInt = circTop + 280;
    
    textWinRect = [0, 0, 600, 200];
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

end

Screen('DrawTexture', MainWindow, instrWin);

    % if instrTrial == 6 && exptSession > 1
%      totalStr = ['In the previous session, you earned $', num2str(starting_total, '%0.2f'), '.\n\nThis will be added to whatever you earn in this session.'];
%      DrawFormattedText(MainWindow, totalStr, scrCentre(1) - instrBox_width / 2, textTop + instrBox_height + 100, yellow, [], [], [], 1.5);
% end

Screen('Flip', MainWindow);
if instrTrial == 2
Image = Screen('GetImage', MainWindow); %this would go after the screen that you want to capture is flipped to the monitor
imwrite(Image, 'filename.jpeg');
end
WaitSecs(instrPause);

Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 0);
DrawFormattedText(instrWin, 'PRESS SPACEBAR WHEN YOU HAVE READ\nAND UNDERSTOOD THESE INSTRUCTIONS', 'center', 970, yellow, [], [], [], 1.5);
Screen('DrawTexture', MainWindow, instrWin);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instrWin);

end

function out = aOrAn(colour)
    if strcmp(colour,'ORANGE')
        out = 'an';
    else
        out = 'a';
    end
end
