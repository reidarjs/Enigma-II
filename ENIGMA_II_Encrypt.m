function CipherText = ENIGMA_II_Encrypt(PlainText,Key)
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

buffer=zeros(1,length(PlainText)); %temporary storage of the ciphertext
capitalization=isstrprop(PlainText,'upper');
PlainText=lower(PlainText); %just some formatting I need


for i=1:length(PlainText)
    if ~isstrprop(PlainText(i),'alpha')
        buffer(i)=PlainText(i);
        continue;
    end
    for n=1:26    
        if PlainText(i)~=char(order(3,arrowpos(3)+1))
            arrowpos(1)=mod(arrowpos(1)+1,26);
            arrowpos(2)=mod(arrowpos(2)-1,26);
            arrowpos(3)=mod(arrowpos(3)+1,26);
        else
            if left==true
                buffer(i)=char(order(1,arrowpos(1)+1));
                left=false;
                break;
            else
                buffer(i)=char(order(2,arrowpos(2)+1));
                left=true;
                break;
            end
        end
    end
end

%The loop above calculates the ciphertext, ignoring numbers and special
%characters

CipherText=char(buffer);

for i=1:length(CipherText)  %ensures correct capitalization
    if capitalization(i)==true
        CipherText(i)=upper(CipherText(i));
    end
end

