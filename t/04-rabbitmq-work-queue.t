#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 18;
use Test::Exception;

use String::Random;

BEGIN {
    use_ok('Daedalus::Hermes') || print "Bail out!\n";
}

my $message = "Ground Control to Major Tom.";

my $HERMES = Daedalus::Hermes->new('rabbitmq');

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { nonsense => {} }
                },
            }
        }
    );

}
qr/Queue options are restricted, "nonsense" in not a valid option./,
  "Queue options names are restricted, nonsense does not exist.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { nonsense => 1 }
                },
            }
        }
    );

}
qr/Queue options are restricted, "nonsense" in not a valid option./,
"Queue options names are restricted, nonsense does not exists unles it has a valid value.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => "nonsense" }
                },
            }
        }
    );

}
qr/Queue options values must have boolean values, 0 or 1. "passive" value is invalid./,
  "Queue options must be boolean, passive has to be 0 or 1.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 2 }
                },
            }
        }
    );

}
qr/Queue options values must have boolean values, 0 or 1. "passive" value is invalid./,
  "Queue options must be 0 or 1.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 2 }
                },
            }
        }
    );

}
qr/Queue options values must have boolean values, 0 or 1. "durable" value is invalid./,
  "Queue options must be 0 or 1.";

# Publish options

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { nonsense => 1 },
                }
            }
        }
    );

}
qr/Publish options are restricted, "nonsense" in not a valid option./,
  "Publish options names are restricted, nonsense does not exist.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { mandatory => "nonsense" },
                }
            }
        }
    );

}
qr/Some publish options values must have boolean values, 0 or 1. "mandatory" value is invalid./,
  "Execept 'exchange', publish options must have boolean values.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose         => "test_queue_sed_receive",
                    channel         => 2,
                    queue_options   => { passive => 1, durable => 1 },
                    publish_options => { mandatory => 1, exchange => 1 },
                }
            }
        }
    );

}
qr/"exchange" publish option is invalid, must be a string./,
  "'exchange'  publish option must a string.";

ok(
    $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 0 }
                },
            }
        }
      )

);

ok(
    $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 0, durable => 0 }
                },
            }
        }
      )

);

ok(
    $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 0, durable => 0 },
                    publish_options => { mandatory => 0 }
                },
            }
        }
      )

);

ok(
    $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 0, durable => 0 },
                    publish_options =>
                      { mandatory => 0, exchange => "amq.direct" }
                },
            }
        }
      )

);

# AMQP props
throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { mandatory => 1 },
                    amqp_props      => { nonsense  => 1 },
                }
            }
        }
    );

}
qr/AMQP props are restricted, "nonsense" in not a valid prop./,
  "AMQP props names are restricted, nonsense does not exist.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { mandatory => 1 },
                    amqp_props      => { priority  => "nonsense" },
                }
            }
        }
    );

}
qr/Some AMQP props values must be an integer. "priority" value is invalid./,
  "'priority' prop must have integer values.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { mandatory => 1 },
                    amqp_props      => { priority  => 2, content_type => 1 },
                }
            }
        }
    );
}
qr/Some AMQP props values must be strings. "content_type" value is invalid./,
  "'content_type'  prop must a string.";

throws_ok {
    my $hermes = $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 1, durable => 1 },
                    publish_options => { mandatory => 1 },
                    amqp_props      => {
                        priority       => 1,
                        correlation_id => "1",
                        headers        => "nonsense"
                    },
                }
            }
        }
    );

}
qr/Some AMQP props values must be a hash. "headers" value is invalid./,
  "'headers'prop must be a hash.";

ok(
    $HERMES->new(
        {
            host     => 'localhost',
            user     => 'guest',
            password => 'guest',
            port     => 5672,
            queues   => {
                testqueue => {
                    purpose       => "test_queue_sed_receive",
                    channel       => 2,
                    queue_options => { passive => 0, durable => 0 },
                    publish_options =>
                      { mandatory => 0, exchange => "amq.direct" },
                    amqp_props => {
                        priority       => 1,
                        correlation_id => "1",
                        headers        => { something => 1 }
                    },
                },
            }
        }
    )
);

diag("Testing Daedalus::Hermes $Daedalus::Hermes::VERSION, Perl $], $^X");
