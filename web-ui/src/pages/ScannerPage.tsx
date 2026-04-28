type Props = { t: (key: any) => string };

export const ScannerPage = ({ t }: Props) => {
  return (
    <section>
      <h2>{t('scanner.title')}</h2>
      <ul>
        <li>OCR scan + translation via backend function proxy</li>
        <li>Free tier: 3 scans/month</li>
        <li>Premium: unlimited scans + AI summary</li>
        <li>Privacy-first: no scan history persisted by default</li>
      </ul>
    </section>
  );
};
