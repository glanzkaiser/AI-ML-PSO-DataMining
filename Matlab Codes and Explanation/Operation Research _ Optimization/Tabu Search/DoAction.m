

function q=DoAction(p,a)

    switch a(1)
        case 1
            % Swap
            q=DoSwap(p,a(2),a(3));
            
        case 2
            % Reversion
            q=DoReversion(p,a(2),a(3));
            
        case 3
            % Insertion
            q=DoInsertion(p,a(2),a(3));
            
    end

end