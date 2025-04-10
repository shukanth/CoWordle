clc
clear
close all

%Loads simpleGameEngine and the sprites
elements = simpleGameEngine('WordleElements.png',16,16,4,[211,211,211]);

%Variable to keep the while loops running for replayability
playAgain = 1;

%Calls the function for players to input their names
[p1Name, p2Name] = askForName();

%While loop to run the game multiple times
while playAgain == 1
    p2Turn = 1;
    p2Play = 1;

    %While loop that runs for player 2's turn
    while p2Turn <=2 && p2Play ~= 0

        %Creates a matrix for a blank CoWordle template
        TL = [35,35,35,35,35;35,35,35,35,35;35,35,35,35,35;35,35,35,35,35;35,35,35,35,35;35,35,35,35,35];
        BL = [31,31,31,31,31;31,31,31,31,31;31,31,31,31,31;31,31,31,31,31;31,31,31,31,31;31,31,31,31,31];

        %Creates the visuals for the game using the top and bottom layers
        drawScene(elements,BL,TL)
        title('CoWordle')

        %Asks user if they want to play Cowordle and stores their response
        fprintf('Do you want to play CoWordle? y/n \n')
        key = getKeyboardInput(elements);
        pause(0.2);

        %String to be changed when a player types their word
        guessWord = '';

        %If statement that runs if the user wishes to play
        if strcmp(key,'y')

            %Statements that print to command window asking for the word
            %the other player needs to guess and for them to start guessing
            fprintf('You entered YES \n')
            fprintf('%s please input a five-letter word and then press enter: \n', p2Name)
            targetWord = input('','s');
            clc
            fprintf('%s please enter your guess word one letter at a time and press enter: \n', p1Name)
            
            %Creates an array of the alphabet
            abc = 'a':'z';

            %Exits the game if the entered word isn't five letters
            if length(targetWord) ~= 5
                fprintf('You did not enter a five-letter word. \n')
                close(1)
            end

            %Runs while the player hasn't guessed the word correctly
            gameWon = false;
            while ~gameWon

                %Goes through the rows of the game
                for i = 1:6
                    bLetters = [35,35,35,35,35];

                    %Creates a logical array of zeros for both variables
                    correctPositions = false(1,5);
                    doesContain = false(1,5);

                    %Goes through each letter in the word
                    for j = 1:5
                        %This for loop creates the visual for each letter
                        %that is typed, and also creates variables that
                        %will be used in the next for loop

                        %Assigns letter to a number that represents it's
                        %location in the sprite sheet matrix
                        letter = find(abc(1,:) == getKeyboardInput(elements)) + 40;

                        %Finds the letters in ASCII table
                        userLetter = char('a' + letter - 41);

                        %If the word has a certain letter, it changes its
                        %position in the logical array to true
                        doesContain(j) = contains(targetWord,userLetter);

                        %If the letters position is correct, it changes its
                        %position in the logical array to true
                        correctPositions(j) = (targetWord(j) == userLetter);

                        %Creates the new top layer for the letters
                        bLetters(j) = letter;
                        TL(i,:) = bLetters;

                        %Creates the visual with the black letters added
                        drawScene(elements,BL,TL)

                        %Creates the user's guess word by concatenating
                        %each letter
                        guessWord = strcat(guessWord, userLetter);
                    end

                    %Also goes through each letter in the word
                    for k = 1:5
                        %This for loop changes the letter color to white with its
                        %corresponding color background: gray, yellow, or
                        %green

                        %Changes the letters to white
                        wLetters = bLetters - 40;
                        TL(i,:) = wLetters;

                        %Changes the background color to gray
                        BL(i,:) = [34,34,34,34,34];

                        %If the guess has a letter that is in the target word, no
                        %matter the positioning, this for loop changes its
                        %background color to yellow
                        for l = 1:length(doesContain)
                            if doesContain(l) == 1
                                BL(i,l) = 33;
                            end
                        end

                        %If the guess has a letter in the target word and
                        %it is in the correct position it changes its
                        %background color to green. This is after the previous 
                        %for loop because it overrules the background color
                        %yellow and changes it to green if the letter is in 
                        %the correct position
                        for m = 1:length(correctPositions)
                            if correctPositions(m) == 1
                                BL(i,m) = 32;
                            end
                        end
                    end

                    %Goes to the next row of the game, and creates the
                    %changes in the visuals
                    enter = getKeyboardInput(elements);
                    if strcmp(enter, 'return')
                        drawScene(elements,BL,TL)
                        pause(0.2);
                    end

                    %Logical that compares the guess word and the target
                    %word
                    correctWord = strcmp(guessWord,targetWord);

                    %Logical that checks if the game was lost
                    gameLost = (i == 6 && ~correctWord);

                    %Sets the logical for if the game won to true if the
                    %word was correctly guessed
                    if correctWord
                        gameWon = true;
                        break
                    end

                    %Clears the guess wordd for the next round
                    guessWord = '';

                    %Following 2 if statements end the round if the player 
                    %doesn't get the word in 6 tries
                    if gameLost
                        msgbox('Game over. You did not find the word.');
                    end
                end
                if gameLost
                    close(1)
                    break
                end
            end

            %Ends the round if the logical for if the game won is true
            if gameWon
                pause(40)
                msgbox('Congratulations! You found the word!');
                close(1)
            end
        else
            close(1)
        end

        %Asks if player 2 wants to play after player 1's turn if player 2
        %hasn't already played
        if p2Turn == 1
            fprintf('If %s wishes to play press 1. To restart press 0: \n', p2Name)
            p2Play = input('');
        end

        %Increments the loop counter for player 2's turn
        p2Turn = p2Turn + 1;

        %Changes the names for the next round
        temp = p2Name;
        p2Name = p1Name;
        p1Name = temp;
    end
    
    %Asks both players if they want to play again
    playAgain = input('Do you two wish to play again? Press 1 to play again and press 0 to exit: \n');
end

%Function that asks for player's to input their names and stores them
function [p1Name, p2Name] = askForName()
    input1 = input('Enter your name player 1: \n', 's');
    p1Name = input1;
    input2 = input('Enter your name player 2: \n', 's');
    p2Name = input2;
end
