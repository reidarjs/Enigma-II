function PlainText = ENIGMA_II_Decrypt(CipherText,Key)
wheel_7='azyxwvutsrqponmlkjihgfedcb';  %storing the config of the wheels
wheel_6='acedfhgikjlnmoqprtsuwvxzyb';
wheel_5='abcdefghijklmnopqrstuvwxyz';

left=true; %decides if left or middle wheel should be used first

order=zeros(3,26);   %pre-allocation of arrays that stores the ordering of the wheels and arrowpositions
arrowpos=zeros(3,1);

for i=1:3
    if Key(i)=='7'
        order(i,:)=wheel_7;
    elseif Key(i)=='6'
        order(i,:)=wheel_6;
    else
        order(i,:)=wheel_5;
    end
end

for n=4:6
    arrowpos(n-3,1)=find(order(n-3,:)==Key(n));
end

%the loops above decides the ordering and arrowpositions based on the key

arrowpos=arrowpos-1; %this is needed for cooperation between modulo and arrays that are 1-indexed

buffer=zeros(1,length(CipherText)); %temporary storage of the plaintext
capitalization=isstrprop(CipherText,'upper');
CipherText=lower(CipherText); %just some formatting I need


for i=1:length(CipherText)
    if ~isstrprop(CipherText(i),'alpha')
        buffer(i)=CipherText(i);
        continue;
    end
    for n=1:26    
        if left==true
            if CipherText(i)~=order(1,arrowpos(1)+1)
                arrowpos(1)=mod(arrowpos(1)+1,26);
                arrowpos(2)=mod(arrowpos(2)-1,26);
                arrowpos(3)=mod(arrowpos(3)+1,26);
            else
                buffer(i)=char(order(3,arrowpos(3)+1));
                left=false;
                break
            end
        else
            if CipherText(i)~=order(2,arrowpos(2)+1)
                arrowpos(1)=mod(arrowpos(1)+1,26);
                arrowpos(2)=mod(arrowpos(2)-1,26);
                arrowpos(3)=mod(arrowpos(3)+1,26);
            else
                buffer(i)=char(order(3,arrowpos(3)+1));
                left=true;
                break
            end
        end
    end
end

%The loop above calculates the plaintext, ignoring numbers and special
%characters

PlainText=char(buffer);

for i=1:length(PlainText)  %ensures correct capitalization
    if capitalization(i)==true
        PlainText(i)=upper(PlainText(i));
    end
end

