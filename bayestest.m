clear; close all; clc;
load('E:\Studia\L''aquila\WC\Project\data\2K_nn_200Hz\rayvrice.mat');

%1 - rayleigh, 2 - rician
rayClass = [rayleigh09,zeros(size(rayleigh09,1),1)];
rayClass(:,2) = rayClass(:,2)+1;
ricClass = [rician00,ones(size(rician00,1),1)];
ricClass(:,2) = ricClass(:,2)+1;

rayTrain = rayClass(1:floor(0.8*length(rayClass)),:);
ricTrain = ricClass(1:floor(0.8*length(ricClass)),:);

rayTest = rayClass(floor(0.8*length(rayClass)):end,:);
ricTest = ricClass(floor(0.8*length(ricClass)):end,:);

X_train = [rayTrain(:,1); ricTrain(:,1)];
Y_train = [rayTrain(:,2); ricTrain(:,2)];

X_test = [rayTest(:,1); ricTest(:,1)];
Y_test = [rayTest(:,2); ricTest(:,2)];

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