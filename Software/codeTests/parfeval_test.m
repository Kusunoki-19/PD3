p = gcp();
global global_val;
global_val = 0;
% To request multiple evaluations, use a loop.
for idx = 1:10
  f(idx) = parfeval(p,@testFunc,1,idx); % Square size determined by idx
end

% Collect the results as they become available.
magicResults = cell(1,10);
for idx = 1:10
  % fetchNext blocks until next results are available.
  [completedIdx,value] = fetchNext(f);
  magicResults{completedIdx} = value;
  fprintf('global: %d, ', global_val);
  fprintf('input: %d, output: %d.\n', completedIdx, value);
end

function output = testFunc(input) 
output = input * 10
global_val = output
end