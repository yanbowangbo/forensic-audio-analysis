function test_failed = test_uwpfbt(verbose)
%TEST_WFBTPR
%
% Checks perfect reconstruction of the general wavelet transform of different
% filters
%
%
%   Url: http://ltfat.github.io/doc/testing/test_uwpfbt.html

% Copyright (C) 2005-2016 Peter L. Soendergaard <peter@sonderport.dk>.
% This file is part of LTFAT version 2.2.0
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
disp('========= TEST UWPFBT ============');
global LTFAT_TEST_TYPE;
tolerance = 1e-8;
if strcmpi(LTFAT_TEST_TYPE,'single')
   tolerance = 2e-6;
end

test_failed = 0;
if(nargin>0)
   verbose = 1;
else
   verbose = 0;
end

type = {'dec'};
ext = {'per'};


J = 4;
%! Mild tree
wt1 = wfbtinit({'db10',6,'full'});
wt1 = wfbtremove(1,1,wt1,'force');
wt1 = wfbtremove(2,1,wt1,'force');

%! Hardcore tree
wt2 = wfbtinit({'db3',1});
wt2 = wfbtput(1,1,'mband1',wt2);
wt2 = wfbtput(2,2,'mband1',wt2);
wt2 = wfbtput(3,3,'mband1',wt2);
wt2 = wfbtput(3,1,'db10',wt2);
wt2 = wfbtput(4,1,'dgrid2',wt2);
wt2 = wfbtput(5,1,'db2',wt2);

% wt2 = wfbtinit();
% wt2 = wfbtput(0,0,{'db',4},wt2);
% wt2 = wfbtput(1,0,{'algmband',1},wt2);
% wt2 = wfbtput(1,1,{'hden',3},wt2);
% wt2 = wfbtput(2,0,{'dgrid',2},wt2);
% wt2 = wfbtput(2,1,{'dgrid',2},wt2);



test_filters = {

               {'algmband1',J} % 3 filters, uniform, crit. sub.
               {'algmband2',J} % 4 filters, uniform, crit. sub.
               {'db10',J}
               %{{'hden',3},J} % 3 filters, non-uniform, no crit. sub. no correct
               {'dgrid1',J} % 4 filters. sub. fac. 2
               wt1
               wt2
               };

scaling = {'scale','sqrt','noscale'};
scalingInv = scaling(end:-1:1);

interscaling = {'intscale','intsqrt','intnoscale'};
interscalingInv = interscaling(end:-1:1);


for scIdx = 1:numel(scaling)
for iscIdx = 1:numel(interscaling)
%testLen = 4*2^7-1;%(2^J-1);
testLen = 53;
f = tester_rand(testLen,1);

for extIdx=1:length(ext)  
   extCur = ext{extIdx};

   for typeIdx=1:length(type)
     for tt=1:length(test_filters)
        actFilt = test_filters{tt};
         if verbose, if(~isstruct(actFilt))fprintf('J=%d, filt=%s, ext=%s, inLen=%d \n',actFilt{2},actFilt{1},extCur,length(f)); else disp('Custom'); end; end;

        [c,info] = uwpfbt(f,actFilt,scaling{scIdx},interscaling{iscIdx});
        fhat = iuwpfbt(c,actFilt,scalingInv{scIdx},interscalingInv{iscIdx});
        
            err = norm(f-fhat,'fro');
            [test_failed,fail]=ltfatdiditfail(err,test_failed,tolerance);
            if(~verbose)
              if(~isstruct(actFilt))
                  fprintf('J=%d, %5.5s, ext=%4.4s, %s, %s, L=%d, err=%.4e %s \n',actFilt{2},actFilt{1},extCur,scaling{scIdx},interscaling{iscIdx},size(f,1),err,fail); 
              else
                  fprintf('Custom, %s, %s, err=%.4e %s\n',scaling{scIdx},interscaling{iscIdx},err,fail); 
              end;
            end
            if strcmpi(fail,'FAILED')
               if verbose
                 if(~isstruct(actFilt)) fprintf('err=%d, filt=%s, ext=%s, inLen=%d \n',err,actFilt{1},extCur,testLen);else disp('Fail. Custom'); end;
                 figure(1);clf;stem([f,fhat]);
                 figure(2);clf;stem([f-fhat]);
                 break; 
               end
            end
            
            
            fhat2 = iuwpfbt(c,info);
            err = norm(f-fhat2,'fro');
            [test_failed,fail]=ltfatdiditfail(err,test_failed,tolerance);
            
            if(~isstruct(actFilt))
                  fprintf('INFO J=%d, %5.5s, ext=%4.4s, %s, %s, L=%d, err=%.4e %s \n',actFilt{2},actFilt{1},extCur,scaling{scIdx},interscaling{iscIdx},size(f,1),err,fail); 
            else
                  fprintf('INFO Custom, %s, %s, err=%.4e %s\n',scaling{scIdx},interscaling{iscIdx},err,fail); 
            end;
            
            
            if test_failed && verbose, break; end;
        
     end
     if test_failed && verbose, break; end;
   end
   if test_failed && verbose, break; end;
end
end
end




















