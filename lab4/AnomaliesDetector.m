function [ anomaliesArray ] = AnomaliesDetector(t, p)

%mean absolute deviation
threshold = mad(t);
 anomaliesArray = zeros(length(t),1);

for i=1:length(t)
  difference = t(i) - p(i);
  if (difference > threshold)
    anomaliesArray(i) = 1;
  end
  
    
end

end
