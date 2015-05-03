# Submission note

## Model 1: Simple Logistic

```R
// AUC: 0.8700635 
// Evaluate: 0.86~

log1 = glm(Popular ~ NewsDesk + SectionName + SubsectionName, data=train, family=binomial)
```

## Model 2: Simple Text Mining

CART using `Headline`, `Snippet`, `Abstract`

