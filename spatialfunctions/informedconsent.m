function granted = informedconsent

global MainWindow white yellow black gray red
global scrWidth scrCentre


ansButtonWidth = 250;
ansButtonHeight = 100;
ansButtonGap = 50;
granted = 0;


instrWindow = Screen('OpenOffscreenWindow', MainWindow, black);
picWindow = Screen ('OpenOffscreenWindow', MainWindow, black, [0 0 1500 1000]);
ansWindow1 = Screen ('OpenOffscreenWindow', MainWindow, black, [0 0 ansButtonWidth ansButtonHeight]);
ansWindow2 = Screen ('OpenOffscreenWindow', MainWindow, black, [0 0 ansButtonWidth ansButtonHeight]);
Screen('TextFont', instrWindow, 'Segoe UI');
Screen('TextStyle', instrWindow, 0);

informationBrochure = imread('informedconsent.png');
imageHeight = size(informationBrochure,1);
imageWidth = size(informationBrochure,2);
imageTexture = Screen('MakeTexture', MainWindow, informationBrochure);

instrString = 'PARTICIPANT CONSENT: Visual perception and learning to pay attention';
instrString2 = 'You are making a decision whether or not to participate. By clicking the box below you are confirming that you have read the information provided and have decided to participate.';
instrString3 = 'I consent';
instrString4 = 'I DO NOT consent';

imageTop = 100;
centredImageRect = [scrWidth/2 - imageWidth/2, imageTop, scrWidth/2 + imageWidth/2, imageTop + imageHeight];
Screen('DrawTexture', instrWindow, imageTexture, [], centredImageRect)


Screen('TextSize', instrWindow, 40);
DrawFormattedText(instrWindow, instrString, 'center', 50, yellow, 100);
Screen('TextSize', instrWindow, 28);
[~, ny, ~] = DrawFormattedText(instrWindow, instrString2, 'center',centredImageRect(4) + 100, white, 100, [], [], 1.3);
ny2 = ny+50;

ansButtonRect = zeros(2,4);
ansButtonRect(1,:) = [scrCentre(1)-ansButtonWidth-ansButtonGap ny2 scrCentre(1)-ansButtonGap ny2+ansButtonHeight];
ansButtonRect(2,:) = [scrCentre(1)+ansButtonGap ny2 scrCentre(1)+ansButtonWidth+ansButtonGap ny2+ansButtonHeight];

Screen('FillRect', ansWindow1, gray);
Screen('FillRect', ansWindow2, gray);

DrawFormattedText(ansWindow1, instrString3, 'center', 'center', yellow);
DrawFormattedText(ansWindow2, instrString4, 'center', 'center', yellow);

Screen('DrawTexture', MainWindow, instrWindow);
Screen('DrawTexture', MainWindow, ansWindow1, [], ansButtonRect(1,:));
Screen('DrawTexture', MainWindow, ansWindow2, [], ansButtonRect(2,:));
ShowCursor('Arrow');

Screen('Flip', MainWindow);

clickedansButton = 0;
while clickedansButton == 0
    [~, x, y, ~] = GetClicks(MainWindow, 0);
    for i = 1 : 2
        if x > ansButtonRect(i,1) && x < ansButtonRect(i,3) && y > ansButtonRect(i,2) && y < ansButtonRect(i,4)
            clickedansButton = i;
        end
    end
end

if clickedansButton == 1
    granted = 1;
else
    granted = 0;
end

Screen('Flip', MainWindow);

WaitSecs(0.5);

if granted ==1
    DrawFormattedText(MainWindow, 'Thank you! Please press spacebar to read the instructions', 'center', 'center', yellow, [], [], [], 1.5);
else
    DrawFormattedText(MainWindow, 'Please press spacebar to continue', 'center', 'center', yellow, [], [], [], 1.5);
end

Screen('Flip', MainWindow);

RestrictKeysForKbCheck(KbName('Space'));   % Only accept spacebar
KbWait([], 2);

Screen('Flip', MainWindow);


HideCursor;

Screen('Close', instrWindow);
Screen('Close', ansWindow1);
Screen('Close', ansWindow2);

end