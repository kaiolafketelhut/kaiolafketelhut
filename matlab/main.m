% KDP profile (MATLAB / GNU Octave script)
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

fprintf('=== KDP Forum Profile ===\n');
fprintf('Nickname : %s\n', id);
fprintf('Code     : %s\n', code);
fprintf('Role     : %s\n', role);
fprintf('Points   : %d\n', points);
