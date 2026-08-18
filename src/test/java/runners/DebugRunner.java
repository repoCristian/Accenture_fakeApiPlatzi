package runners;

import io.karatelabs.core.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class DebugRunner {
    @Test
    void debugTest() {
        final var result = Runner.path("classpath:features/filters")
                .tags("@debug")
                .outputHtmlReport(true)
                .outputCucumberJson(true)
                .parallel(5);
        assertTrue(result.isPassed());
    }
}