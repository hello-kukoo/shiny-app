
injuries <- vroom::vroom("ms-chapter-04/neiss/injuries.tsv.gz")
injuries

products <- vroom::vroom("ms-chapter-04/neiss/products.tsv")
products

population <- vroom::vroom("ms-chapter-04/neiss/population.tsv")
population

prod_codes <- setNames(products$prod_code, products$title)

# Looking at a product: 649 (toilet) --------------------------------------

selected <- injuries %>% filter(prod_code == 649)
nrow(selected)

selected %>% count(location, wt = weight, sort = TRUE)

selected %>% count(body_part, wt = weight, sort = TRUE)

selected %>% count(diag, wt = weight, sort = TRUE)

summary <- selected %>%
  count(age, sex, wt = weight)
summary

summary %>%
  ggplot(aes(age, n, colour = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")

summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)
summary

summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10,000 people")

selected %>%
  sample_n(10) %>%
  pull(narrative)
