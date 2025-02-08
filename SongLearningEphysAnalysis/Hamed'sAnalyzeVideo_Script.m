
  
                 vid_path = 'X:\CorinnaNeuropixSleepData\data\r5n5\20201023_02\corrected1fpsFrames\'
                   
                   imageNames = dir(fullfile(vid_path, '*.png'));
                   imageNames = {imageNames.name}';
                    nImags = numel(imageNames);
                   
                    frames = 1:nImags;
                    
                    %app.roi_y=1:1024;  app.roi_x=1:1280;
                    % In case a smaller ROI needs to be defined
                    %roi_y = 1:1024;
                    roi_y = 1:380;
                    roi_x = 1:1280;
                    
                    img1 = imread([vid_path imageNames{frames(1)}]);
                    im1=double(img1(roi_y,roi_x));
                    acc_dif=zeros(size(im1)); % contains accumulated absolute value of consecutive differences
                    
                    % creating wait bar to display progress
                %  f = waitbar(0,'Analysing frames...');
                  tic;
                  
                  % difining some variables that are used in the loop
                  y_pixls=1:size(im1,1);  y_vals=y_pixls'/sum(y_pixls); % a vector of values from 0 to 1 with ...
                  % a length equal to the height of the image. Also the same for length
                  x_pixls=1:size(im1,2);  x_vals=x_pixls'/sum(x_pixls);
                  % loop through frames
                  
                  for i= frames(2:end)
                      % this section of the lop generates the r_dif variable,
                      
                      img2 = imread([vid_path imageNames{i}]);
                       im2=double(img2(roi_y,roi_x));
                 
                      dif=abs(im2-im1);   % difference computation
                      y_dif=sum(dif,2); % difference along vertical axis
                      x_dif=sum(dif,1); % difference along horizontal axis
                      % computing the weighted average of moved pixels (dif) along y and x:
                      y_dif_mean=y_dif'*y_vals;
                      x_dif_mean=x_dif*x_vals;
                      r_dif(i)=sqrt(x_dif_mean^2 + y_dif_mean^2); % position of the center of changes in the current ...
                      % following frames (r in polar coordinates)
                      
                      
                      % this section of the loop is for the acc_diff (accumulated differences) that shows all of the
                      % movements occuring during the specific frames of the video. It just
                      % does not accumulate the whole differences in all single frames because
                      % there are many speckle random points that are different in two
                      % following frames. So we also make a mask and filter out the single
                      % points thatt their change doesnt seem to be consistent in time. To do
                      % that we compare the current difference matrix with the previous one and
                      % consider a point as REAL difference only if it appears in both of these
                      % matrices
                      %if i==frames(2), dif_old=zeros(size(dif)); end
                      if i==frames(2), dif_old=zeros(size(dif)); end
                      avg_dif=(dif+dif_old)/2;
                      dif_thresh=median(avg_dif) + 5*iqr(abs(avg_dif)); % threshold for considering a point as..
                      % a consistant difference
                      mask=avg_dif>dif_thresh; % to make sure that these points are constantly changing, ...
                      % at least in 2 consecutive frames, not just speckle noise spots
                      acc_dif=acc_dif+mask.*abs(dif); % accumulated absolute value of consecutive differences
                      im1=im2; % consider x_new as x_old for the next comparison
                      dif_old=dif;
                      
                      %{
                      % update waitbar
                      if rem(i,20)==0
                          x=(length(frames)-(i-frames(1)))*toc/(i-frames(1));
                          waitbar((i-frames(1))/length(frames),f,['Remaining time: ' num2str(ceil(x/60)) ' min...']);
                      end
                      %}
                      if rem(i,1000)==0
                          disp([ 'frame number being read: ' num2str(i) ' ...']); % disply the current frame value
                      end
                      
                  end
                  last_im=im1;
                  last_dif=dif;
                 % waitbar(1,f,'Video read completely!');
          
                  figure; plot(r_dif)
                  xlabel('Time (s)')
                
mic=[]
