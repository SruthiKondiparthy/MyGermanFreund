import { useMemo, useState } from 'react';
import { dictionary, Locale } from './dictionary';

export const useLocale = () => {
  const [locale, setLocale] = useState<Locale>('en');

  const t = useMemo(() => {
    return (key: keyof (typeof dictionary)['en']) => dictionary[locale][key] ?? key;
  }, [locale]);

  return {
    locale,
    t,
    toggleLocale: () => setLocale((prev) => (prev === 'en' ? 'de' : 'en')),
  };
};
