%computer error rate on a per-file basis
%Input:
%   test_date -- test example struct
%   tree -- previously computed decision tree
%Return:
%   distrib_matrix -- confusion matrix contain file count for language i
%       predicted as j for all possible combinations of i,j.
function [distrib_matrix, correct_matrix]=dtfiletest(test_data,tree)

    en_marker=test_data.en_marker;
    fr_marker=test_data.fr_marker;
    ge_marker=test_data.ge_marker;
    enY=test_data.en_Y;
    frY=test_data.fr_Y;
    geY=test_data.ge_Y;
    enX=test_data.en_X;
    frX=test_data.fr_X;
    geX=test_data.ge_X;

    %test on each language separately
    [distrib_matrix, correct_matrix, en_raw_output] = dttest(enX,enY,tree);
    [distrib_matrix, correct_matrix, fr_raw_output] = dttest(frX,frY,tree);
    [distrib_matrix, correct_matrix, ge_raw_output] = dttest(geX,geY,tree);

    [en_f,en_distrib_matrix] = dtsimplefiletest(enY, en_raw_output, en_marker);
    [fr_f,fr_distrib_matrix] = dtsimplefiletest(frY, fr_raw_output, fr_marker);
    [ge_f,ge_distrib_matrix] = dtsimplefiletest(geY, ge_raw_output, ge_marker);

    %combine test results
    distrib_matrix=en_distrib_matrix+fr_distrib_matrix+ge_distrib_matrix;


    correct_matrix=zeros(4);
    f=en_f+fr_f+ge_f;
    for i=1:3
        for j=1:3
            correct_matrix(i,j)=distrib_matrix(i,j)/f;
        end
    end

    correct_matrix(4,4)=distrib_matrix(4,4)/f;
    for j=1:3
        correct_matrix(j,4)=distrib_matrix(j,j)/distrib_matrix(j,4);
    end
    
end
