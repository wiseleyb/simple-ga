# from http://www.dreamincode.net/forums/topic/266807-ruby-challenge-genetic-algorithms/

$population_size = 100 #keep it dividable by 4 pls
$mutation_rate = 0.01 #chance an individual letter mutates

$alphabet = "abcdefghijklmnopqrstuvwxyz".chars.to_a 

#generate a random population
population = []
$population_size.times {
    population.push($alphabet.shuffle)
}

#fitness function, less is better
def fitness(candidate)
    #sum of squared differences of ascii value of letters and their corresponding letter in the alphabet
    $alphabet.zip(candidate).map{|x| (x[1].ord-x[0].ord)**2}.inject(:+)
end

#creates number_of_children children by crossover from parent1 and 2 and some mutation
def crossover_and_mutate(parent1, parent2, number_of_children)
    children = []
    for i in 0...number_of_children
        child = []
        for i in 0...parent1.size
            if rand() < $mutation_rate #mutate
                #push a random character a-z
                child.push( ('a'.ord + rand('z'.ord-'a'.ord+1)).chr );
            elsif rand() < 0.5 #take character from parent1
                child.push(parent1[i])
            else #take character from parent2
                child.push(parent2[i])
            end
        end
        children.push(child)
    end
    children
end

#loop through generations
while (true)
    #simple tournament selection
    #this code splits the population in 2 groups and compares group1[i] with group2[i] for all i,
    #selecting the fittest each time
    mid = population.size/2
    group1 = population[0...mid]
    group2 = population[mid..-1]
    parents = group1.zip(group2).map{|x| fitness(x[0]) < fitness(x[1]) ? x[0] : x[1] }

    #we do the same as above to take the fittest 2 by 2 and generate new offspring
    mid = parents.size/2
    group1 = parents[0...mid]
    group2 = parents[mid..-1]
    population = []
    group1.zip(group2).each{|x| population.push(*crossover_and_mutate(x[0],x[1],4)) }

    #this part is for monitoring
    steps ||= 1; steps += 1
    fittest = population.min_by {|x| fitness(x)}
    puts "#{steps}: #{fittest.join}  #{fitness(fittest)}"
    if fitness(fittest) == 0
        break
    end    
end
