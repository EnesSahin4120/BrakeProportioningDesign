frictionCoefficient = 0.81; %dimensionless
wheelbase = 120.0; % inch
heightCG = 30.0; %inch
staticLoadFront = 2000.0; %lb
staticLoadRear = 1800.0; %lb
deceleration = 0.7; %g

weight = staticLoadFront + staticLoadRear;
b = weight * deceleration;
ratioH_to_L = heightCG / wheelbase;
mf = frictionCoefficient * ratioH_to_L / (1.0 - frictionCoefficient * ratioH_to_L);
bf = frictionCoefficient * staticLoadFront / (1.0 - frictionCoefficient * ratioH_to_L);
mrDv = -frictionCoefficient * ratioH_to_L / (1.0 + frictionCoefficient * ratioH_to_L);
brDv = frictionCoefficient * staticLoadRear / (1.0 + frictionCoefficient * ratioH_to_L);
mr = 1.0 / mrDv;
br = -brDv / mrDv;
intersectionX = (br - bf) / (mf - mr);
intersectionY = mf * intersectionX + bf;

x_front = linspace(0, 1500, 100); 
y_rear = linspace(0, 2900, 100); 
x_deceleration = linspace(0, b, 100); 
x_proportioning = linspace(0, 900, 100); 

% Front lockup curve: y = mf * x + bf
y_front = mf * x_front + bf;

% Rear lockup curve: x = mrDv * y + brDv
x_rear = mrDv * y_rear + brDv;

% Deceleration line: y = b - x
y_deceleration = b - x_deceleration;

% Proportioning line: y = (3000 / 1000) * x
y_proportioning = (3250 / 1000) * x_proportioning;

% Intersection front brake curve with deceleration line
x_intersection_front = (b - bf) / (mf + 1);
y_intersection_front = mf * x_intersection_front + bf;

% Intersection rear brake curve with deceleration line
% Solving for x: b - x = mr * x + br
x_intersection_rear = (b - br) / (1 + mr);
y_intersection_rear = mr * x_intersection_rear + br;

figure;
hold on;

plot(x_front, y_front, 'k-', 'LineWidth', 1.25);
plot(x_rear,y_rear , 'k-', 'LineWidth', 1.25);
plot(x_deceleration, y_deceleration, 'k--', 'LineWidth', 1.25);
plot(x_proportioning, y_proportioning, 'k-', 'LineWidth', 1.75);

% Fill the area between p1, p2, and p3
x_fill = [intersectionX, x_intersection_front, x_intersection_rear];
y_fill = [intersectionY, y_intersection_front, y_intersection_rear];
fill(x_fill, y_fill, 'k', 'EdgeAlpha', 0.5);

text(1510, 2420, 'Front Lockup Curve', 'FontSize', 12, 'Color', 'black');
text(370, 2900, 'Rear Lockup Curve', 'FontSize', 12, 'Color', 'black');
text(210, 650, 'Proportioning Line', 'FontSize', 12, 'Color', 'black');
text(2050, 650, 'Deceleration = 0.7', 'FontSize', 12, 'Color', 'black');
text(610, 2100, 'Safe Region', 'FontSize', 12, 'Color', 'white');

xlabel('Rear Brake Force (lb)', 'FontSize', 15);
ylabel('Front Brake Force (lb)', 'FontSize', 15);
title('Brake Proportioning Design', 'FontSize', 15, 'Color', 'black');

grid on;
hold off;