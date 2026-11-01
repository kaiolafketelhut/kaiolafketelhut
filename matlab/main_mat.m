% Main for kdp.mat: load the saved KDP profile and print it.
% Works in MATLAB and GNU Octave. Run from the matlab/ folder.
if ~exist('kdp.mat', 'file')
    error('kdp.mat not found - run make_mat.m first');
end

load('kdp.mat');   % id, role, points, code

fprintf('=== KDP Forum Profile ===\n');
fprintf('Nickname : %s\n', id);
fprintf('Code     : %s\n', code);
fprintf('Role     : %s\n', role);
fprintf('Points   : %d\n', points);
