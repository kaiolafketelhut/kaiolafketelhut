% Build matlab/kdp.mat from the KDP profile, then read it back.
% Works in MATLAB and GNU Octave.
id     = 'KDPMember:KL5UQ4f48673352';
role   = 'Member';
points = 1;

% The short code after the "KDPMember:" prefix
prefix = 'KDPMember:';
if strncmp(id, prefix, length(prefix))
    code = id(length(prefix)+1:end);
else
    code = id;
end

% -v7 is the format MATLAB reads by default
save('-v7', 'kdp.mat', 'id', 'role', 'points', 'code');

clear;
load('kdp.mat');
fprintf('=== KDP Forum Profile (from kdp.mat) ===\n');
fprintf('Nickname : %s\n', id);
fprintf('Code     : %s\n', code);
fprintf('Role     : %s\n', role);
fprintf('Points   : %d\n', points);
