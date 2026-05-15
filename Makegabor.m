function gabor=Makegabor(imSize,lamda,sigma,phase,theta,contrast)
% imSize =150;                           % image size: n X n
% lamda = 15;                             % wavelength (number of pixels per cycle)
% theta = -15;                              % grating orientation
% sigma = 20;                             % gaussian standard deviation in pixels
% phase = rand(1);                            % phase (0 -> 1)
% contrast=0.25;
trim = .005;                             % trim off gaussian values smaller than this
backluminance=0.5;
%make linear ramp
X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;                 % rescale X -> -.5 to .5
%plot a one-dimensional sinewave
sinX = sin(X0 * 2*pi);                  % convert to radians and do sine
freq = imSize/lamda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)
sinX = sin(Xf) ;                        % make new sinewave
% plot(sinX, 'r-');                       % plot in red
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
sinX = sin( Xf + phaseRad) ;            % make phase-shifted sinewave
% Start with a 2D ramp use meshgrid to make 2 matrices with ramp values across columns (Xm) or across rows (Ym) respectively
[Xm Ym] = meshgrid(X0, X0);             % 2D matrices
% Put 2D ramps through sine
Xf = Xm * freq * 2*pi;
grating = sin( Xf + phaseRad);          % make 2D sinewave
% Change orientation by adding Xm and Ym together in different proportions
thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);                   % make 2D sinewave
% first look at the 1D function
s = sigma / imSize;                     % gaussian width as fraction of imageSize
Xg = exp( -( ( (X0.^2) ) ./ (2* s^2) ));% formula for 1D gaussian
Xg = normpdf(X0, 0, (20/imSize)); Xg = Xg/max(Xg);  % alternative using normalized probability function (stats toolbox)
% Make 2D gaussian blob
gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
% Now multply grating and gaussian to get a GABOR
gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
gabor= grating .* gauss*contrast+backluminance;                % use .* dot-product