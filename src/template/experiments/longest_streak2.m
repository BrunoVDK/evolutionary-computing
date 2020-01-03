function [longest] = longest_streak2(best_list, delta)
        current_value = []; % since best -1 does not exist
        current_counter = 0;
        best_sofar = 0;
        i = 1;
        while i <= size(best_list,2)
            t = best_list(1,i);
            if (size(current_value,2) > 0)
                frac = 1 - (t/current_value(1,1));
            else
                frac = delta + 1;
            end
            
            if (size(current_value,2) > 0) && (frac >= delta)
                if current_counter > best_sofar
                    best_sofar = current_counter;
                end
                while (size(current_value,2) > 0) && ((1 - (t/current_value(1,1))) >= delta)
                    if size(current_value,2) == 1
                        current_value = [];
                    else
                        current_value = current_value(2:size(current_value,2));
                    end
                    current_counter = current_counter - 1;
                end
                if size(current_value,2) == 0
                    current_counter = 1;
                end
            else
                current_counter = current_counter + 1;
            end
            current_value(size(current_value)+1) = t;
            i = i + 1;
        end
        longest = best_sofar;
    end

