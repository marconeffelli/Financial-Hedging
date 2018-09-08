function [HR] = MVHR(x,y,mgarch)

% function BiMVHR
% 
% N.B. This function is based on the Kevin Sheppard MFE toolbox,
% downloadable at https://www.kevinsheppard.com/MFE_Toolbox.
%
% Description:
% this function calculates the Minimum Variance Hedge Ratio (heceforth MVHR) 
% for a couple of spot-futures financial assets. Variance and Covariance
% are expressed by their conditional counterparts, and estimated through
% conditional multivariate volatility models - MGARCHs - in a bivariate
% form. The MVHR is expressed as a positive value.
%
% Inputs:
% - a string of spot asset returns, variable x
% - a string of futures asset returns, variable y
% - the type of mgarch model. Select among ewma, bekk, gogarch, ccc, dcc, 
%   rcc and rarch.
%
% Usage:
% HR = MVHR(x,y,'dcc')
%
% This version: 09/2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is released under the BSD 2-clause license.

% Copyright (c) 2018, Marco Neffelli 
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%dimensions check
[t1,n1]=size(x);
[t2,n2]=size(y);
if n1~=n2
    msg = 'column dimensions disagree.';
    error(msg)
end
if t1~=t2
    msg = 'row dimensions disagree.';
    error(msg)
end

%concatenate spot and futures
r = [x y];

%calculate conditional VCV matrix HT with mgarch
if mgarch == "ewma"
    HT = riskmetrics(r,0.94); %conditional VCV matrix
end
if mgarch == "bekk"
    [~,~,HT] = bekk(r,[],1,0,1);
end
if mgarch == "gogarch"
    [~,~,HT] = gogarch(r,1,1);
end
if mgarch == "ccc"
    [~,~,HT] = ccc_mvgarch(r,[],1,0,1); 
end
if mgarch == "dcc"
    [~,~,HT] = dcc(r,[],1,0,1);
end
if mgarch == "rcc"
    [~,~,HT] = rcc(r,[],1,1);
end
if mgarch == "rarch"
    [~,~,HT] = rarch(r,[],1,1);
end

%calculate the Minimum Variance Hedge Ratio
HR = HT(1,1,end)\HT(2,1,end); %(var)^(-1) * cov
end