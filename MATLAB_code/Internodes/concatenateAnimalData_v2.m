% edited CLC 20180427
function [M,P] = concatenateAnimalData(compiledIntData)
    anim = fieldnames(compiledIntData);
    M = struct;
    for a = 1:(length(anim)-1)
        desig = fieldnames(compiledIntData.(anim{a}).mean);
        for d = 1:length(desig)
            if a==1
                M.(desig{d}) = []; %prealloc for concatenation
            end
            if isstruct(compiledIntData.(anim{a}).mean.(desig{d}))
                M.(desig{d}) = [M.(desig{d}),cell2mat(struct2cell(compiledIntData.(anim{a}).mean.(desig{d})))];
            elseif contains(desig{d},{'repltot','chngtot'})
                M.(desig{d}) = [M.(desig{d}),compiledIntData.(anim{a}).mean.(desig{d})];
            end
        end
    end
    P = struct;
    for d = 1:length(desig)
        if strcmp(desig{d},'repl') || strcmp(desig{d},'chng')
            continue
        else
            P.(desig{d}) = [];
            P.(desig{d}) = M.(desig{d})(1:end-1,:) ./ M.(desig{d})(end,:);
        end
        avg = [];
        sem = [];
        for k = 1:size(P.(desig{d}),1)
            avg = [avg; mean(P.(desig{d})(k,:),'omitnan')];
            sem = [sem; calcSEM(P.(desig{d})(k,:),2)];
        end
        P.(desig{d}) = [P.(desig{d}), avg, sem];
    end
end

    