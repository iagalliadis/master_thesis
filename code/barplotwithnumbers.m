Features = {'smooth','rms','stft','haar','db8','sym4','sym8','bior1.3','bior2.2','coif3','coif4'};
perfs = [0.617 0.531 0.618 0.633 0.629 0.635 0.63 0.64 0.629 0.629 0.631];
bar(perfs)

for i1=1:numel(perfs)
   t = text(i1,perfs(i1)/2,num2str(perfs(i1)*100,'%0.1f'),'Color','white',...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom');
end
set(gca,'XTickLabel',Features(:),'XTickLabelRotation',45)
%title('Average perfs with 1 hidden layer, 5 neurons and step 64')