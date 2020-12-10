% code that simulates a basic model of planatary motion around the sun 

clear 
clc
%% planet set up
% load data
    % load planet data
    opts = spreadsheetImportOptions("NumVariables", 4);
    
    % Specify sheet and range
    opts.Sheet = "Sheet1";
    opts.DataRange = "B3:E11";
    
    % Specify column names and types
    opts.VariableNames = ["Planet", "Radiusoforbitrelativetothatofearth", "Lengthofyearrelativetoearths", "orbitalvelocityrelativetoearth"];
    opts.VariableTypes = ["string", "double", "double", "double"];
    
    % Specify variable properties
    opts = setvaropts(opts, "Planet", "WhitespaceRule", "preserve");
    opts = setvaropts(opts, "Planet", "EmptyFieldRule", "auto");
    
    % Import the data
    Relativevaluesofplanets = readtable("C:\Users\user\Documents\MATLAB\intrege calcs\Solar system\Relative values of planets.xlsx", opts, "UseExcel", false);

% earth stats
    Scale_factor = 1 % make plot size smaller and change planet speeds
    Earth_Speed = 67000*Scale_factor;  % mph
    Earth_dist_sun = 93000000*Scale_factor; % miles

% planet radius 
    Radius = Earth_dist_sun .* Relativevaluesofplanets.Radiusoforbitrelativetothatofearth;

% find planet change in angle per step
    planetspeed = Earth_Speed .* Relativevaluesofplanets.orbitalvelocityrelativetoearth; % (mph) find speed of planets 
    DelTheta = zeros(1,9); % initialize for itaration
    
    time_period_per_step = 672; % time step per iteration in hours
    
for g = 1:9 % itarate through to find change in angle between planets for each step
    DelTheta(g) = ((planetspeed(g)*time_period_per_step) / (pi * 2 * Radius(g))) * 360;
end
%% Initialize animation

% initialize starting positions
    x = zeros(1,9);
    y = Radius;

% Calculate for number of itrations for pluto to do one cycle. This
% helps in calculating the length of the animation. 
    
    Pluto_orbit_number_of_steps = floor(360 / DelTheta(9)); % how many steps it takes pluto to complete an orbit rounded down to nearest whole number

% Length of animation
    Length_of_animation = Pluto_orbit_number_of_steps * 1;

%% Run animation

for i = 1:Length_of_animation
    
    % plot point
        plot(x,y,'ro'); % plot planet position
        hold on
        ylim([-Radius(9) - (Radius(9)*0.1), Radius(9) + (Radius(9)*0.1)]); % set limits of y axis
        xlim([-Radius(9) - (Radius(9)*0.1), Radius(9) + (Radius(9)*0.1)]); % set limits of x axis
        plot(0,0,'bo'); % plot sun
        xlabel('Miles from sun')
        ylabel('Miles from sun')
        title('Solar system annimation')
        
        for n = 1:9
            text(x(n),y(n),Relativevaluesofplanets.Planet(n)) % label planets
        end
        
        text(0,0,'Sun') % label sun
        hold off
        
        solar_system_movie(i) = getframe(gcf); % capture frames for movie
       
    % calculate position of new point
        for g = 1:9
            a = [cosd(DelTheta(g)), -sind(DelTheta(g)); sind(DelTheta(g)), cosd(DelTheta(g))]; % rotation matrix a
            b = [x(g);y(g)]; % rotation matrix b with current x and y positions
            c = a * b; % solve matrix to find new x and y positions

        % save position of new values for the x and y arrays
            x(g) = c(1); % save x(g) value
            y(g) = c(2); % save y(g) value
            
        end 

end

%% Create MP4 file of animation

Vid = VideoWriter('solar_system_movie','MPEG-4');
open(Vid);
writeVideo(Vid,solar_system_movie);
close(Vid);

