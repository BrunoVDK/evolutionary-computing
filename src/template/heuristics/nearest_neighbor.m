function [path] = nearest_neighbors(distances)
    nb_cities = size(distances,1);
    distances(1:1+nb_cities:end) = realmax;
    current = randi(nb_cities);
    path = zeros(1,nb_cities);
    path(1) = current;
    for i = 2:nb_cities
        [~,next] = min(distances(current,:));
        path(i) = next;
        distances(:,current) = realmax;
        current = next;
    end
end