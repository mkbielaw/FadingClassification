clear; close all; clc;
load('E:\Studia\L''aquila\WC\Project\data\2K_nn_200Hz\40K.mat');
load('E:\Studia\L''aquila\WC\Project\data\2K_12EbNo_200Hz\testDATA40K.mat');

%1 - rayleigh, 2 - rician
rayTrain = [rayleigh09,zeros(size(rayleigh09,1),1)];
rayTrain(:,2) = rayTrain(:,2)+1;
ricTrain = [rician00,ones(size(rician00,1),1)];
ricTrain(:,2) = ricTrain(:,2)+1;

rayTest = [rayleigh09test,zeros(size(rayleigh09test,1),1)];
rayTest(:,2) = rayTest(:,2)+1;
ricTest = [rician00test,ones(size(rician00test,1),1)];
ricTest(:,2) = ricTest(:,2)+1;

X_train = [rayTrain(:,1); ricTrain(:,1)];
Y_train = [rayTrain(:,2); ricTrain(:,2)];

X_test = [rayTest(:,1); ricTest(:,1)];
Y_test = [rayTest(:,2); ricTest(:,2)];

%PROBABILISTIC GENERATIVE START____________________________________________

% Estimate class priors
class_priors = tabulate(Y_train);
class_priors = class_priors(:,3)/100;

% Estimate class-conditional densities
class_conditional_densities = cell(2,1);
%Rayleigh
class_conditional_densities{1} = fitdist(X_train(Y_train == 1,:),'Rayleigh');
%Rician
class_conditional_densities{2} = fitdist(X_train(Y_train == 2,:),'Rician');

% Apply Bayes' rule for classification
Y_pred = zeros(size(X_test,1),1);
for i = 1:size(X_test,1)
    posterior_probs = zeros(2,1);
    for j = 1:2
        posterior_probs(j) = class_priors(j)*pdf(class_conditional_densities{j},X_test(i,:));
    end
    [~,Y_pred(i)] = max(posterior_probs);
end

% Compute accuracy
acc = mean(Y_pred == Y_test);

% Display results
fprintf('Accuracy: %.2f%%\n',acc*100);

%PROBABILISTIC GENERATIVE END______________________________________________

%{
s = class_conditional_densities{2}.s;
sigma = class_conditional_densities{2}.sigma;
x = 0:0.01:2.5;
RicDist = makedist('Rician','sigma',sigma,'s',s);
%}