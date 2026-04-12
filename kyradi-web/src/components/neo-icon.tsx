type NeoIconProps = {
  symbol: string;
  tone?: 'cyan' | 'pink' | 'green' | 'amber' | 'violet';
  size?: 'sm' | 'md' | 'lg';
};

export function NeoIcon({ symbol, tone = 'cyan', size = 'md' }: NeoIconProps) {
  return (
    <span className={`neo-icon neo-${tone} neo-${size}`} aria-hidden="true">
      <span className="neo-icon-core">{symbol}</span>
    </span>
  );
}
