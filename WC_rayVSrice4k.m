clear; close all; clc;
load('E:\Studia\L''aquila\WC\Project\data\4K\K25_0-9-4-26(best)\4K_nn_200Hz\40K.mat')
load('E:\Studia\L''aquila\WC\Project\data\4K\K25_0-9-4-26(best)\4K_nn_200Hz\testDATA40K.mat')

%1 - rayleigh07, 2 - rician00, 3 - rayleigh21, 4 - rician14

ray1Train = [rayleigh07,zeros(size(rayleigh07,1),1)];
ray1Train(:,2) = ray1Train(:,2)+1;
ric1Train = [rician00,ones(size(rician00,1),1)];
ric1Train(:,2) = ric1Train(:,2)+1;

ray1Test = [rayleigh07test,zeros(size(rayleigh07test,1),1)];
ray1Test(:,2) = ray1Test(:,2)+1;
ric1Test = [rician00test,ones(size(rician00test,1),1)];
ric1Test(:,2) = ric1Test(:,2)+1;

ray2Train = [rayleigh21,zeros(size(rayleigh21,1),1)];
ray2Train(:,2) = ray2Train(:,2)+3;
ric2Train = [rician14,ones(size(rician14,1),1)];
ric2Train(:,2) = ric2Train(:,2)+3;

ray2Test = [rayleigh21test,zeros(size(rayleigh21test,1),1)];
ray2Test(:,2) = ray2Test(:,2)+3;
ric2Test = [rician00test,ones(size(rician00test,1),1)];
ric2Test(:,2) = ric2Test(:,2)+3;

X_train = [ray1Train(:,1); ric1Train(:,1); ray2Train(:,1); ric2Train(:,1)];
Y_train = [ray1Train(:,2); ric1Train(:,2); ray2Train(:,2); ric2Train(:,2)];

X_test = [ray1Test(:,1); ric1Test(:,1); ray2Test(:,1); ric2Test(:,1)];
Y_test = [ray1Test(:,2); ric1Test(:,2); ray2Test(:,2); ric2Test(:,2)];

%PROBABILISTIC GENERATIVE START____________________________________________

% Estimate class priors
class_priors = tabulate(Y_train);
class_priors = class_priors(:,3)/100;

% Estimate class-conditional densities
class_conditional_densities = cell(4,1);
%Rayleigh07
class_conditional_densities{1} = fitdist(X_train(Y_train == 1,:),'Rayleigh');
%Rician00
class_conditional_densities{2} = fitdist(X_train(Y_train == 2,:),'Rician');
%Rayleigh21
class_conditional_densities{3} = fitdist(X_train(Y_train == 3,:),'Rayleigh');
%Rician14
class_conditional_densities{4} = fitdist(X_train(Y_train == 4,:),'Rician');

% Apply Bayes' rule for classification
Y_pred = zeros(size(X_test,1),1);
for i = 1:size(X_test,1)
    posterior_probs = zeros(4,1);
    for j = 1:4
        posterior_probs(j) = class_priors(j)*pdf(class_conditional_densities{j},X_test(i,:));
    end
    [~,Y_pred(i)] = max(posterior_probs);
end

% Compute accuracy
acc = mean(Y_pred == Y_test);

% Display results
fprintf('Accuracy: %.2f%%\n',acc*100);

%PROBABILISTIC GENERATIVE END______________________________________________