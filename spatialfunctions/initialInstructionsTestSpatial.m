function initialInstructionsTestSpatial()

global MainWindow scrCentre
global white black gray yellow red

initialInstructionsSpatial()
%{
initialInstructTest_iti= 1;

ansButtonWidth = 1000;
ansButtonHeight = 100;
ansButtonTop = 400;
ansButtonDisplacement = 150;

ansButtonWin = zeros(2,1);

questionOptions = [3,2];

ques = {'What is your aim in this task?', 'Which of these options is correct?'};
answersQ1 = {'To locate and respond to the line inside the diamond', 'To locate and respond to the line inside the coloured circle', 'To remember which location the diamond is in'};
answersQ2 = {'If the line inside the diamond is horizontal I should press the M button\nand if the line is vertical I should press the C button','If the line inside the diamond is horizontal I should press the C button\nand if the line is vertical I should press the M button'};
 %n.b. for the first question the 1ST answer is correct, for the second question the 2ND answer is correct.

for question = 1:2
    
    for i = 1 : questionOptions(question)
        ansButtonWin(i) = Screen('OpenOffscreenWindow', MainWindow, black, [0 0 ansButtonWidth ansButtonHeight]);
        Screen('FillRect', ansButtonWin(i), gray);
        Screen('TextSize', ansButtonWin(i), 30);
        Screen('TextFont', ansButtonWin(i), 'Calibri');
        if question == 1
            DrawFormattedText(ansButtonWin(i), char(answersQ1(i)), 'center', 'center', yellow);
        else
            DrawFormattedText(ansButtonWin(i), char(answersQ2(i)), 'center', 'center', yellow);
        end
    end
    
    
    ansButtonRect = zeros(3,4);
    ansButtonRect(1,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop   scrCentre(1) + ansButtonWidth/2   ansButtonTop + ansButtonHeight];
    ansButtonRect(2,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop + ansButtonDisplacement    scrCentre(1) + ansButtonWidth/2    ansButtonTop + ansButtonDisplacement + ansButtonHeight];
    ansButtonRect(3,:) = [scrCentre(1) - ansButtonWidth/2   ansButtonTop + ansButtonDisplacement*2    scrCentre(1) + ansButtonWidth/2   ansButtonTop + ansButtonDisplacement*2 + ansButtonHeight];
    
    
    mouseInstruct = 'Use the mouse to select the correct answer';
    
    ShowCursor('Arrow');
    Screen('TextFont', MainWindow, 'Segoe UI');
    Screen('TextSize', MainWindow, 34);
    
    %DRAW THE QUESTION
    DrawFormattedText(MainWindow, char(ques(question)), 'center', 100, white, 50, [], [], 1.5);
    DrawFormattedText(MainWindow, mouseInstruct, 'center', 300, white, 50, [], [], 1.5);
    
    
    
    % show first three answer options (e.g. that pertain to this q)
    for i = 1 : questionOptions(question)
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
        
        if (question == 1 && clickedansButton == 1)||(question == 2 && clickedansButton == 2)
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
    
end



HideCursor;
for i = 1:3
    Screen('Close', ansButtonWin(i));
end
%}
HideCursor;

DrawFormattedText(MainWindow, 'You now have the chance to see what the game will look like.\n\nPlease place your fingers on the C and M keys\nand press the spacebar to begin the demo!!', 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);
RestrictKeysForKbCheck([]); % Re-enable all keys

Screen('Flip', MainWindow);
end

% spatial

function initialInstructionsSpatial()

global MainWindow white

instructStr1 = 'Thanks for agreeing to take part!\n\nIn this experiment you will play a TARGET DETECTION game.\n\nPlease press space to find out how the game works.';
instructStr2 = 'On each trial a cross will appear, to warn you that the trial is about to start. Then a set of shapes will appear; an example is shown below.';
instructStr3 = 'Each of these shapes contains a line. Your task is to respond to the line that is contained inside the DIAMOND shape.\n\nIf the line inside the diamond is HORIZONTAL, you should press the C key. If the line is VERTICAL, you should press the M key.';
instructStr4 = 'You should respond as fast as you can, but you should try to avoid making errors.';

show_Instructions(1, instructStr1, 1);
show_Instructions(2, instructStr2, 1);
show_Instructions(3, instructStr3, 1);
show_Instructions(4, instructStr4, 1);
%{
Screen('TextSize', MainWindow, 32);
Screen('TextStyle', MainWindow, 1);
Screen('TextFont', MainWindow, 'Segoe UI');

DrawFormattedText(MainWindow, 'Please press space to begin.', 'center', 'center' , white);
Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);
Screen('Flip', MainWindow);
RestrictKeysForKbCheck([]); % Re-enable all keys
%}
end

function show_Instructions(instrTrial, insStr, instrPause)

global MainWindow scrCentre black white yellow

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar

instrWin = Screen('OpenOffscreenWindow', MainWindow, black);
Screen('TextFont', instrWin, 'Segoe UI');
Screen('TextSize', instrWin, 32);
Screen('TextStyle', instrWin, 1);


if instrTrial == 1
    Screen('TextSize', instrWin, 40);
    DrawFormattedText(instrWin, insStr, 'center', 400, white, [], [], [], 1.5);

else    
    Screen('TextSize', instrWin, 32);
    DrawFormattedText(instrWin, insStr, 540, 120, white, 60, [], [], 1.5);
    exampleImageMatrix = imread('spatialExample.jpg', 'jpg');
    exampleImageRect = [0,0,size(exampleImageMatrix, 2), size(exampleImageMatrix, 1)];
    Screen('PutImage', instrWin, exampleImageMatrix, CenterRectOnPoint(exampleImageRect, scrCentre(1), 680)); % put example image on screen

    Screen('DrawTexture', MainWindow, instrWin);
    Screen('Flip', MainWindow);
    
    WaitSecs(instrPause);
    
    Screen('TextSize', instrWin, 26);
    Screen('TextStyle', instrWin, 0);
    DrawFormattedText(instrWin, 'PRESS SPACEBAR WHEN YOU HAVE READ AND UNDERSTOOD THESE INSTRUCTIONS', 'center', 1020, yellow, [], [], [], 1.4);

end

Screen('DrawTexture', MainWindow, instrWin);

Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Close', instrWin);

end