# Included Clusters Expression

Groups and Namespaces have a field called Included Clusters Expression that when populated expands to a list of clusters.

## Format

/\<entity-char\>/\<expression-vallue\>
entity-char - can be g for group, n for namespace, or c for cluster
expression-value - the name or id of a cluster, namespace, or group - for a group the name has to include the value of the entire tree i.e. in a group structure where ther is a group hierarchy with country>state>city, for a group representing the city of Round Rock, the value would need to be /usa/texas/round_rock

## Operators

Expressions can be chained together with the logical operators:

- and - this operator implements an intersection of sets
- or - this operator implements a union of sets

Parentheses can be used to group expressions together
