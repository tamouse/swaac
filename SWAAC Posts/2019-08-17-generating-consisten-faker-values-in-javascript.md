broken-links:nil

**WARNING: This is old and likely obsolete.**

Generating Consistent Faker Values in JavaScript {#generating-consistent-faker-values-in-javascript-1}
================================================

So this is good to know. I hadn\'t seen this before.

When using [faker.js](https://github.com/Marak/Faker.js), you can generate the exact same data each time by setting the **seed**:

``` {.javascript}
import faker from "faker"

faker.seed(123);

export const testData = {
    id: faker.number.uuid(),
    name: `${faker.name.firstName()} ${faker.name.lastName()}`,
    email: fakcer.internat.email()
}

```

Which would give the same data each time.
