# For Emacs: -*- mode:cperl; mode:folding; coding:utf-8 -*-

package Lingua::DEU::Word2Num;
# ABSTRACT: Lingua::DEU::Word2Num is module for converting text containing number representation in German back into number. Converts whole numbers from 0 up to 999 999 999.

# {{{ use block

use strict;
use warnings;

use Encode                    qw(decode_utf8);
use Parse::RecDescent;
use Perl6::Export::Attrs;

# }}}
# {{{ variables

our $VERSION = '';
my $parser   = deu_numerals();

# }}}
# {{{ w2n                       convert number to text

sub w2n :Export {
    my $input = shift // return;

    return $parser->numeral($input);
}

# }}}
# {{{ deu_numerals              create parser for german numerals

sub deu_numerals {
    return Parse::RecDescent->new(decode_utf8(q{
      numeral:      <rulevar: local $number = 0>
      numeral:       millenium
                    { return $item[1]; }
                  |  century
                    { return $item[1]; }
                  |  decade
                    { return $item[1]; }
                  | { return undef; }

      number:       'dreizehn'  { $return = 13; }
                  | 'vierzehn'  { $return = 14; }
                  | 'fünfzehn'  { $return = 15; }
                  | 'sechzehn'  { $return = 16; }
                  | 'siebzehn'  { $return = 17; }
                  | 'achtzehn'  { $return = 18; }
                  | 'neunzehn'  { $return = 19; }
                  | 'null'      { $return =  0; }
                  | 'ein'       { $return =  1; }
                  | 'zwei'      { $return =  2; }
                  | 'drei'      { $return =  3; }
                  | 'vier'      { $return =  4; }
                  | 'fünf'      { $return =  5; }
                  | 'sechs'     { $return =  6; }
                  | 'sieben'    { $return =  7; }
                  | 'acht'      { $return =  8; }
                  | 'neun'      { $return =  9; }
                  | 'zehn'      { $return = 10; }
                  | 'elf'       { $return = 11; }
                  | 'zwölf'     { $return = 12; }

      tens:       'zwanzig'  { $return = 20; }
                | 'dreissig' { $return = 30; }
                | 'vierzig'  { $return = 40; }
                | 'fünfzig'  { $return = 50; }
                | 'sechzig'  { $return = 60; }
                | 'siebzig'  { $return = 70; }
                | 'achtzig'  { $return = 80; }
                | 'neunzig'  { $return = 90; }

      decade:      'und' decade
                   { $return = $item[2]; }
                 |  number 'und' tens
                    { $return = $item[1] + $item[3]; }
                 | tens
                   { $return = $item[1]; }
                 | number
                   { $return = $item[1]; }

      century:  number 'hundert' decade
                { $return = $item[1] * 100 + $item[3]; }
                | number 'hundert'
                { $return = $item[1] * 100; }
                | 'hundert'
                { $return = 100; }

    millenium:    century 'tausend' century
                { $return = $item[1] * 1000 + $item[3]; }
                | century 'tausend' decade
                { $return = $item[1] * 1000 + $item[3]; }
                | decade  'tausend' century
                { $return = $item[1] * 1000 + $item[3]; }
                | decade  'tausend' decade
                { $return = $item[1] * 1000 + $item[3]; }
                | decade  'tausend'
                { $return = $item[1] * 1000; }
                | century 'tausend'
                { $return = $item[1] * 1000; }

    }));
}

# }}}

1;

__END__

# {{{ POD HEAD

=pod

=head1 NAME

Lingua::DEU::Word2Num

=head1 VERSION

version 666

text to positive number convertor for German.
Input text must be in encoded in utf-8.

=head2 $Rev: 419 $

ISO 639-3 namespace.

=head1 SYNOPSIS

 use Lingua::DEU::Word2Num;

 my $num = Lingua::DEU::Word2Num::w2n( 'siebzehn' );

 print defined($num) ? $num : "sorry, can't convert this text into number.";

=head1 DESCRIPTION

Lingua::DEU::Word2Num is module for converting text containing number
representation in German back into number. Converts whole numbers from 0 up
to 999 999 999.

=cut

# }}}
# {{{ Functions reference

=pod

=head2 Functions Reference

=over

=item w2n (positional)

  1   string  string to convert
  =>  number  converted number
      undef   if input string is not known

Convert text representation to number.

=item deu_numerals

Internal parser.

=back

=cut

# }}}
# {{{ POD FOOTER

=pod

=head1 EXPORT_OK

w2n

=head1 KNOWN BUGS

None.

=head1 AUTHOR

 coding, maintenance, refactoring, extensions, specifications:
   Richard C. Jelinek <info@petamem.com>
 initial coding after specification by R. Jelinek:
   Roman Vasicek <info@petamem.com>

=head1 COPYRIGHT

Copyright (C) PetaMem, s.r.o. 2004-present

=head2 LICENSE

Artistic license or BSD license.

=cut

# }}}
