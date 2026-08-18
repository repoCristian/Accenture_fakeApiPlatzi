package runners;

import io.karatelabs.core.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class AllTestRunner {
    @Test
    void runnerTest() {
        final var result = Runner.path("classpath:features")
                .outputHtmlReport(true)
                .parallel(10);
        assertTrue(result.isPassed());
    }
}