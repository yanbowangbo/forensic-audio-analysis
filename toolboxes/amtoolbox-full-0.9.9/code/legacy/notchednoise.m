function out=notchednoise(varargin)

warning('Warning: NOTCHEDNOISE will be removed in a future release. Use SIG_NOTCHEDNOISE instead. ');  

out=sig_notchednoise(varargin{:});
%
%   Url: http://amtoolbox.sourceforge.net/amt-0.9.9/doc/legacy/notchednoise.php

% Copyright (C) 2009-2015 Piotr Majdak and the AMT team.
% This file is part of Auditory Modeling Toolbox (AMT) version 0.9.9
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
out=sig_notchednoise(varargin{:});
