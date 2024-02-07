# Included Clusters Expression

Groups and Namespaces have a field called Included Clusters Expression that, when populated, expands to a list of clusters.

## Format

```/<entity-char>/<expression-value>```

- entity-char can be:
  - g for group
  - n for namespace
  - c for cluster
  - m for metadata
- expression-value is the name or id of a cluster, namespace, or group. For a group, the name must include the value of the entire tree; for example, in a group structure with a hierarchy of `country > state > city`, for a group representing the city of Round Rock, the value would need to be `/usa/texas/round_rock`. Additionally, you can set an expression value to match metadata specific to the cluster, for example, `/m/type/corp` will match all clusters that contain the metadata with the key-value pair `type:corp`.

## Operators

Expressions can be chained together with the logical operators:

- and - this operator implements an intersection of sets
- or - this operator implements a union of sets
- not - this operator implements a negation of the expression

Parentheses can be used to group expressions together.
